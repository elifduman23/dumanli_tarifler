using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YemekSiparisi.Api.Data;
using YemekSiparisi.Api.Models;

namespace YemekSiparisi.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MenuItemController : ControllerBase
    {
        private readonly AppDbContext _context;

        public MenuItemController(AppDbContext context)
        {
            _context = context;
        }

        // Tüm benzersiz kategorileri getir
        [HttpGet("categories")]
        public async Task<IActionResult> GetCategories()
        {
            var categories = await _context.MenuItems
                .Select(m => m.Category)
                .Distinct()
                .ToListAsync();
            
            return Ok(categories);
        }

        // Kategoriye göre yemekleri getir
        [HttpGet("category/{categoryName}")]
        public async Task<IActionResult> GetByCategory(string categoryName)
        {
            var items = await _context.MenuItems
                .Include(m => m.Restaurant)
                .Where(m => m.Category.ToLower() == categoryName.ToLower())
                .ToListAsync();
            
            return Ok(items);
        }

        // Tüm yemekleri getir
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var items = await _context.MenuItems.Include(m => m.Restaurant).ToListAsync();
            return Ok(items);
        }
        [HttpGet("search/{query}")]
        public async Task<IActionResult> Search(string query)
        {
            var items = await _context.MenuItems
                .Include(m => m.Restaurant)
                .Where(m => m.Name.Contains(query) || m.Category.Contains(query))
                .ToListAsync();
            return Ok(items);
        }
    }
}
