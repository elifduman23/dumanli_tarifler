using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YemekSiparisi.Api.Data;
using YemekSiparisi.Api.Models;

namespace YemekSiparisi.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantController : ControllerBase
    {
        private readonly AppDbContext _context;

        public RestaurantController(AppDbContext context)
        {
            _context = context;
        }

        // Tüm restoranları listele (Herkese açık)
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var restaurants = await _context.Restaurants.Include(r => r.MenuItems).ToListAsync();
            return Ok(restaurants);
        }

        // Restoran detay (Herkese açık)
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var restaurant = await _context.Restaurants.Include(r => r.MenuItems).FirstOrDefaultAsync(r => r.Id == id);
            if (restaurant == null) return NotFound("Restoran bulunamadı.");
            return Ok(restaurant);
        }

        // Yeni restoran ekle (Sadece Admin veya RestaurantOwner)
        [Authorize(Roles = "Admin,RestaurantOwner")]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Restaurant restaurant)
        {
            _context.Restaurants.Add(restaurant);
            await _context.SaveChangesAsync();
            return Ok(restaurant);
        }

        // Menüye ürün ekle
        [Authorize(Roles = "Admin,RestaurantOwner")]
        [HttpPost("{restaurantId}/menu")]
        public async Task<IActionResult> AddMenuItem(int restaurantId, [FromBody] MenuItem menuItem)
        {
            var restaurant = await _context.Restaurants.FindAsync(restaurantId);
            if (restaurant == null) return NotFound("Restoran bulunamadı.");

            menuItem.RestaurantId = restaurantId;
            _context.MenuItems.Add(menuItem);
            await _context.SaveChangesAsync();

            return Ok(menuItem);
        }
        // Örnek verileri doldur (Tohumlama)
        [HttpGet("seed")]
        public async Task<IActionResult> Seed()
        {
            try 
            {
                // Mevcut verileri temizle (Kullanıcıları silmiyoruz!)
                _context.OrderItems.RemoveRange(_context.OrderItems);
                _context.Orders.RemoveRange(_context.Orders);
                _context.Favorites.RemoveRange(_context.Favorites);
                _context.MenuItems.RemoveRange(_context.MenuItems);
                _context.Restaurants.RemoveRange(_context.Restaurants);
                await _context.SaveChangesAsync();

                // İlk kullanıcıyı (yani seni) buluyoruz
                var owner = await _context.Users.FirstOrDefaultAsync();
                if (owner == null)
                {
                    return BadRequest("Hata: Önce uygulamadan kayıt olmalısınız!");
                }

                var res1 = new Restaurant { Name = "Dumanlı Burger Sarayı", Description = "Köz ateşinde pişmiş dev burgerler.", LogoUrl = "https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=500", Address = "Beşiktaş, İstanbul", OwnerId = owner.Id };
                var res2 = new Restaurant { Name = "Pizza & Pasta Venedik", Description = "Gerçek İtalyan pizzası ve el yapımı makarnalar.", LogoUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500", Address = "Kadıköy, İstanbul", OwnerId = owner.Id };
                var res3 = new Restaurant { Name = "Kebapçı Dünyası", Description = "Gaziantep usulü zırh kebapları ve lahmacun.", LogoUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500", Address = "Çankaya, Ankara", OwnerId = owner.Id };
                var res4 = new Restaurant { Name = "Tokyo Sushi Express", Description = "Taze sushiler ve Uzak Doğu lezzetleri.", LogoUrl = "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500", Address = "Şişli, İstanbul", OwnerId = owner.Id };
                var res5 = new Restaurant { Name = "Mavi Deniz Ürünleri", Description = "Ege'den taze balıklar ve deniz mahsulleri.", LogoUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=500", Address = "Bebek, İstanbul", OwnerId = owner.Id };
                var res6 = new Restaurant { Name = "Anadolu Ev Yemekleri", Description = "Sıcak tencere yemekleri ve zeytinyağlılar.", LogoUrl = "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?q=80&w=500", Address = "Üsküdar, İstanbul", OwnerId = owner.Id };
                var res7 = new Restaurant { Name = "Dumanlı Kahvaltı Bahçesi", Description = "Yöresel serpme kahvaltılar ve börekler.", LogoUrl = "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?q=80&w=500", Address = "Sarıyer, İstanbul", OwnerId = owner.Id };

                _context.Restaurants.AddRange(res1, res2, res3, res4, res5, res6, res7);
                await _context.SaveChangesAsync();

                var items = new List<MenuItem>
                {
                    // BURGERLER
                    new MenuItem { Name = "Dumanlı Klasik Burger", Description = "150g Köfte, cheddar, karamelize soğan", Price = 185, Category = "Burger", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500" },
                    new MenuItem { Name = "Truffle Mushroom Burger", Description = "Trüf yağı, mantar sote, emmental peyniri", Price = 245, Category = "Burger", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500" },
                    new MenuItem { Name = "Acılı Meksika Burger", Description = "Jalapeno, özel acı sos, mısır cipsi", Price = 195, Category = "Burger", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500" },
                    new MenuItem { Name = "Barbekü Tavuk Burger", Description = "Çıtır tavuk, barbekü sos, marul", Price = 165, Category = "Burger", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500" },
                    new MenuItem { Name = "Veggie Delight Burger", Description = "Sebze köftesi, avokado sos, roka", Price = 175, Category = "Burger", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500" },
                    
                    // PİZZALAR & MAKARNALAR
                    new MenuItem { Name = "Margherita Special", Description = "Bufalo mozzarella, taze fesleğen", Price = 175, Category = "Pizza", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500" },
                    new MenuItem { Name = "Acılı Pepperoni", Description = "Dana pepperoni, kekik, özel sos", Price = 215, Category = "Pizza", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500" },
                    new MenuItem { Name = "Dört Mevsim Pizza", Description = "Enginar, mantar, zeytin, mısır", Price = 195, Category = "Pizza", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500" },
                    new MenuItem { Name = "Barbekü Tavuklu Pizza", Description = "Tavuk parçaları, mısır, barbekü sos", Price = 205, Category = "Pizza", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500" },
                    new MenuItem { Name = "Fettuccine Alfredo", Description = "Taze makarna, tavuk, krema sos", Price = 210, Category = "Makarna", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1645112481357-ca2493d05586?q=80&w=500" },
                    new MenuItem { Name = "Penne Arrabbiata", Description = "Acılı domates sosu, siyah zeytin", Price = 180, Category = "Makarna", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1645112481357-ca2493d05586?q=80&w=500" },

                    // KEBAPLAR & DÖNERLER
                    new MenuItem { Name = "Zırh Kıyma Adana", Description = "El zırhı kıyma, köz biber", Price = 260, Category = "Kebap", RestaurantId = res3.Id, ImageUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500" },
                    new MenuItem { Name = "Urfa Kebap", Description = "Acısız zırh kıyması, lavaş eşliğinde", Price = 260, Category = "Kebap", RestaurantId = res3.Id, ImageUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500" },
                    new MenuItem { Name = "Özel İskender", Description = "Bursa usulü yaprak döner, bol tereyağı", Price = 320, Category = "Döner", RestaurantId = res3.Id, ImageUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500" },
                    new MenuItem { Name = "Yaprak Döner Porsiyon", Description = "%100 Dana eti, pilav üstü", Price = 280, Category = "Döner", RestaurantId = res3.Id, ImageUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500" },
                    new MenuItem { Name = "Çıtır Lahmacun", Description = "Gaziantep usulü, tane fiyatı", Price = 65, Category = "Kebap", RestaurantId = res3.Id, ImageUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500" },
                    
                    // TATLILAR
                    new MenuItem { Name = "Fıstıklı Künefe", Description = "Sıcak şerbetli, Antep fıstıklı", Price = 145, Category = "Tatlı", RestaurantId = res5.Id, ImageUrl = "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=500" },
                    new MenuItem { Name = "Dumanlı Brownie", Description = "Sıcak çikolatalı, dondurmalı", Price = 135, Category = "Tatlı", RestaurantId = res5.Id, ImageUrl = "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=500" },
                    new MenuItem { Name = "San Sebastian Cheesecake", Description = "Yumuşak dokulu, yanık üst yüzey", Price = 155, Category = "Tatlı", RestaurantId = res5.Id, ImageUrl = "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=500" },
                    new MenuItem { Name = "Sütlaç (Fırın)", Description = "Geleneksel lezzet, bol fındıklı", Price = 95, Category = "Tatlı", RestaurantId = res5.Id, ImageUrl = "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=500" },

                    // İÇECEKLER
                    new MenuItem { Name = "Taze Sıkma Portakal Suyu", Description = "Günlük taze meyvelerden", Price = 85, Category = "İçecek", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500" },
                    new MenuItem { Name = "Ev Yapımı Limonata", Description = "Nane ve taze limon ile", Price = 75, Category = "İçecek", RestaurantId = res2.Id, ImageUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500" },
                    new MenuItem { Name = "Naneli Yayık Ayran", Description = "Bol köpüklü, doğal", Price = 45, Category = "İçecek", RestaurantId = res3.Id, ImageUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=500" },
                    new MenuItem { Name = "Coca Cola (330ml)", Description = "Kutu içecek", Price = 55, Category = "İçecek", RestaurantId = res1.Id, ImageUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500" },
                    
                    // UZAK DOĞU & DENİZ ÜRÜNLERİ
                    new MenuItem { Name = "California Roll (8pc)", Description = "Surimi, avokado, salatalık", Price = 280, Category = "Sushi", RestaurantId = res4.Id, ImageUrl = "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500" },
                    new MenuItem { Name = "Salmon Teriyaki", Description = "Teriyaki soslu ızgara somon", Price = 420, Category = "Deniz Ürünleri", RestaurantId = res5.Id, ImageUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=500" }
                };

                _context.MenuItems.AddRange(items);
                await _context.SaveChangesAsync();

                return Ok("Uygulama Uzak Doğu'dan Anadolu'ya dev bir lezzet portalına dönüştü! Afiyet olsun.");
            }
            catch (Exception ex)
            {
                return BadRequest("Hata Oluştu: " + ex.Message + (ex.InnerException != null ? " | Detay: " + ex.InnerException.Message : ""));
            }
        }
    }
}
