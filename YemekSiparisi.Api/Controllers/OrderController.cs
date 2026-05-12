using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YemekSiparisi.Api.Data;
using YemekSiparisi.Api.Models;
using System.Security.Claims;

namespace YemekSiparisi.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize] // Sadece giriş yapmış kullanıcılar sipariş verebilir
    public class OrderController : ControllerBase
    {
        private readonly AppDbContext _context;

        public OrderController(AppDbContext context)
        {
            _context = context;
        }

        // Yeni sipariş oluştur
        [HttpPost]
        public async Task<IActionResult> CreateOrder([FromBody] CreateOrderDto request)
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId)) return Unauthorized();

            var order = new Order
            {
                UserId = userId,
                RestaurantId = request.RestaurantId,
                Status = "Hazırlanıyor",
                OrderDate = DateTime.UtcNow,
                OrderItems = new List<OrderItem>()
            };

            decimal totalAmount = 0;

            foreach (var item in request.Items)
            {
                var menuItem = await _context.MenuItems.FindAsync(item.MenuItemId);
                if (menuItem != null)
                {
                    // İndirimli fiyat varsa onu kullan, yoksa normal fiyatı
                    decimal unitPrice = menuItem.DiscountPrice ?? menuItem.Price;

                    var orderItem = new OrderItem
                    {
                        MenuItemId = item.MenuItemId,
                        Quantity = item.Quantity,
                        UnitPrice = unitPrice
                    };
                    order.OrderItems.Add(orderItem);
                    totalAmount += (unitPrice * item.Quantity);
                }
            }

            // KUPON UYGULAMA
            if (!string.IsNullOrEmpty(request.CouponCode))
            {
                var coupon = await _context.Coupons.FirstOrDefaultAsync(c => 
                    c.Code == request.CouponCode && 
                    c.UserId == userId && 
                    !c.IsUsed);

                if (coupon != null)
                {
                    if (coupon.DiscountType == "Percentage")
                    {
                        totalAmount -= (totalAmount * (coupon.DiscountValue / 100));
                    }
                    else if (coupon.DiscountType == "Flat")
                    {
                        totalAmount -= coupon.DiscountValue;
                    }
                    
                    if (totalAmount < 0) totalAmount = 0; // Fiyat eksiye düşmesin

                    coupon.IsUsed = true; // Kuponu kullanıldı yap
                }
            }

            order.TotalAmount = totalAmount;

            _context.Orders.Add(order);
            
            // BİLDİRİM EKLE
            var notification = new Notification
            {
                UserId = userId,
                Title = "Sipariş Alındı 🥘",
                Message = "Siparişiniz başarıyla mutfağa ulaştı. Hazırlanmaya başlıyor!",
                CreatedAt = DateTime.Now
            };
            _context.Notifications.Add(notification);

            await _context.SaveChangesAsync();

            return Ok(new { 
                Message = "Siparişiniz başarıyla alındı ve ödeme tamamlandı.", 
                OrderId = order.Id, 
                Total = order.TotalAmount 
            });
        }

        // Kullanıcının siparişlerini getir
        [HttpGet("my-orders")]
        public async Task<IActionResult> GetMyOrders()
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId)) return Unauthorized();

            var orders = await _context.Orders
                .Include(o => o.Restaurant)
                .Include(o => o.OrderItems)
                .ThenInclude(oi => oi.MenuItem)
                .Where(o => o.UserId == userId)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            return Ok(orders);
        }

        // TÜM SİPARİŞLERİ GETİR (Admin Paneli İçin)
        [HttpGet("all-orders")]
        public async Task<IActionResult> GetAllOrders()
        {
            var orders = await _context.Orders
                .Include(o => o.Restaurant)
                .Include(o => o.User)
                .Include(o => o.OrderItems)
                .ThenInclude(oi => oi.MenuItem)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            return Ok(orders);
        }
        // Sipariş durumunu güncelle (Admin veya Restoran Sahibi için)
        [HttpPatch("{orderId}/status")]
        public async Task<IActionResult> UpdateStatus(int orderId, [FromBody] string newStatus)
        {
            var order = await _context.Orders
                .Include(o => o.Restaurant)
                .FirstOrDefaultAsync(o => o.Id == orderId);
                
            if (order == null) return NotFound("Sipariş bulunamadı.");

            order.Status = newStatus;

            // BİLDİRİM EKLE
            string title = "Sipariş Durumu Güncellendi 🔔";
            string message = $"Siparişiniz şu an: {newStatus}";

            if (newStatus == "Yolda") {
                title = "Siparişin Yola Çıktı! 🛵";
                message = $"{order.Restaurant?.Name} siparişini kuryeye teslim etti. Çok yakında kapında!";
            } else if (newStatus == "Teslim Edildi") {
                title = "Afiyet Olsun! 😋";
                message = "Siparişin başarıyla teslim edildi. Bizi tercih ettiğin için teşekkürler!";
            }

            var notification = new Notification
            {
                UserId = order.UserId,
                Title = title,
                Message = message,
                CreatedAt = DateTime.Now
            };
            _context.Notifications.Add(notification);

            await _context.SaveChangesAsync();

            return Ok(new { Message = "Sipariş durumu güncellendi.", Status = newStatus });
        }
    }

    public class CreateOrderDto
    {
        public int RestaurantId { get; set; }
        public string? CouponCode { get; set; }
        public List<OrderItemDto> Items { get; set; }
    }

    public class OrderItemDto
    {
        public int MenuItemId { get; set; }
        public int Quantity { get; set; }
    }
}
