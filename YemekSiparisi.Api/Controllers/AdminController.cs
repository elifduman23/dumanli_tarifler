using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YemekSiparisi.Api.Data;
using YemekSiparisi.Api.Models;

namespace YemekSiparisi.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AdminController(AppDbContext context)
        {
            _context = context;
        }

        // TÜM KULLANICILARI GETİR
        [HttpGet("users")]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _context.Users
                .Select(u => new {
                    u.Id,
                    u.FullName,
                    u.Email,
                    u.Role,
                    u.Province,
                    u.District,
                    u.Neighborhood,
                    u.CreatedAt
                })
                .OrderByDescending(u => u.CreatedAt)
                .ToListAsync();

            return Ok(users);
        }

        // İSTATİSTİKLER (Opsiyonel ama hoca sever)
        [HttpGet("stats")]
        public async Task<IActionResult> GetStats()
        {
            var totalUsers = await _context.Users.CountAsync();
            var totalOrders = await _context.Orders.CountAsync();
            var totalRestaurants = await _context.Restaurants.CountAsync();
            var totalRevenue = await _context.Orders.SumAsync(o => o.TotalAmount);

            return Ok(new {
                totalUsers,
                totalOrders,
                totalRestaurants,
                totalRevenue
            });
        }
    }
}
