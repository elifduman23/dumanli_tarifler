using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using YemekSiparisi.Api.Data;
using YemekSiparisi.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace YemekSiparisi.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;

        public AuthController(AppDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] UserRegisterDto request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                return BadRequest("Bu e-posta adresi zaten kullanılıyor.");
            }

            bool isFirstUser = !await _context.Users.AnyAsync();

            var user = new User
            {
                FullName = request.FullName,
                Email = request.Email,
                PasswordHash = request.Password, 
                Role = isFirstUser ? "Admin" : "Customer",
                Province = request.Province,
                District = request.District,
                Neighborhood = request.Neighborhood
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            // HOŞ GELDİN KUPONU TANIMLA
            var coupons = new List<Coupon>
            {
                new Coupon { 
                    UserId = user.Id, 
                    Code = "BEDAVA2344", 
                    Description = "Tüm Siparişlerde Geçerli %50 İndirim", 
                    DiscountType = "Percentage", 
                    DiscountValue = 50 
                }
            };

            _context.Coupons.AddRange(coupons);
            await _context.SaveChangesAsync();

            return Ok(new { Message = "Kayıt başarılı. Hoş geldin kuponlarınız tanımlandı!" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserLoginDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email && u.PasswordHash == request.Password);

            if (user == null)
            {
                return Unauthorized("Geçersiz e-posta veya şifre.");
            }

            var token = GenerateJwtToken(user);

            return Ok(new { 
                success = true,
                token = token, 
                role = user.Role, 
                fullName = user.FullName, 
                email = user.Email,
                province = user.Province,
                district = user.District,
                neighborhood = user.Neighborhood
            });
        }

        // PROFİL GÜNCELLE (Adres vb.)
        [HttpPatch("update-profile")]
        [Authorize]
        public async Task<IActionResult> UpdateProfile([FromBody] UserUpdateDto request)
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId)) return Unauthorized();

            var user = await _context.Users.FindAsync(userId);
            if (user == null) return NotFound("Kullanıcı bulunamadı.");

            if (!string.IsNullOrEmpty(request.Province)) user.Province = request.Province;
            if (!string.IsNullOrEmpty(request.District)) user.District = request.District;
            if (!string.IsNullOrEmpty(request.Neighborhood)) user.Neighborhood = request.Neighborhood;

            await _context.SaveChangesAsync();

            return Ok(new { Message = "Profil başarıyla güncellendi.", Province = user.Province, District = user.District, Neighborhood = user.Neighborhood });
        }

        // KULLANICININ KUPONLARINI GETİR
        [HttpGet("my-coupons")]
        [Authorize]
        public async Task<IActionResult> GetMyCoupons()
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId)) return Unauthorized();

            var coupons = await _context.Coupons
                .Where(c => c.UserId == userId && !c.IsUsed)
                .ToListAsync();

            return Ok(coupons);
        }

        private string GenerateJwtToken(User user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.FullName),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role),
                new Claim("Province", user.Province ?? ""),
                new Claim("District", user.District ?? ""),
                new Claim("Neighborhood", user.Neighborhood ?? "")
            };

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.Now.AddHours(2),
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }

    public class UserRegisterDto
    {
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string? Role { get; set; }
        public string? Province { get; set; }
        public string? District { get; set; }
        public string? Neighborhood { get; set; }
    }

    public class UserLoginDto
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }

    public class UserUpdateDto
    {
        public string? Province { get; set; }
        public string? District { get; set; }
        public string? Neighborhood { get; set; }
    }
}
