using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using YemekSiparisi.Api.Data;
using YemekSiparisi.Api.Models;

namespace YemekSiparisi.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class FavoriteController : ControllerBase
    {
        private readonly AppDbContext _context;

        public FavoriteController(AppDbContext context)
        {
            _context = context;
        }

        // Favorilere ekle / çıkar (Toggle)
        [HttpPost("{restaurantId}")]
        public async Task<IActionResult> ToggleFavorite(int restaurantId)
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId)) return Unauthorized();

            var existing = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == userId && f.RestaurantId == restaurantId);

            if (existing != null)
            {
                _context.Favorites.Remove(existing);
                await _context.SaveChangesAsync();
                return Ok(new { Message = "Favorilerden çıkarıldı.", IsFavorite = false });
            }
            else
            {
                var favorite = new Favorite { UserId = userId, RestaurantId = restaurantId };
                _context.Favorites.Add(favorite);
                await _context.SaveChangesAsync();
                return Ok(new { Message = "Favorilere eklendi.", IsFavorite = true });
            }
        }

        // Kullanıcının favorilerini getir
        [HttpGet]
        public async Task<IActionResult> GetMyFavorites()
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId)) return Unauthorized();

            var favorites = await _context.Favorites
                .Include(f => f.Restaurant)
                .Where(f => f.UserId == userId)
                .Select(f => f.Restaurant)
                .ToListAsync();

            return Ok(favorites);
        }
    }
}
