using Microsoft.EntityFrameworkCore;
using YemekSiparisi.Api.Models;

namespace YemekSiparisi.Api.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Restaurant> Restaurants { get; set; }
        public DbSet<MenuItem> MenuItems { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<Coupon> Coupons { get; set; }
        public DbSet<Favorite> Favorites { get; set; }
        public DbSet<Notification> Notifications { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // Favoriler için çoklu silme yolunu engelle
            modelBuilder.Entity<Favorite>()
                .HasOne(f => f.User)
                .WithMany()
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.Restrict); // Kullanıcı silindiğinde favorileri koru (veya manuel sil)

            modelBuilder.Entity<Favorite>()
                .HasOne(f => f.Restaurant)
                .WithMany()
                .HasForeignKey(f => f.RestaurantId)
                .OnDelete(DeleteBehavior.Cascade);

            // Decimal precision için
            modelBuilder.Entity<MenuItem>()
                .Property(m => m.Price)
                .HasColumnType("decimal(18,2)");
                
            modelBuilder.Entity<MenuItem>()
                .Property(m => m.DiscountPrice)
                .HasColumnType("decimal(18,2)");
                
            modelBuilder.Entity<Order>()
                .Property(o => o.TotalAmount)
                .HasColumnType("decimal(18,2)");
                
            modelBuilder.Entity<OrderItem>()
                .Property(oi => oi.UnitPrice)
                .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<Coupon>()
                .Property(c => c.DiscountValue)
                .HasColumnType("decimal(18,2)");

            // İlişkileri tanımlama
            modelBuilder.Entity<Order>()
                .HasOne(o => o.Restaurant)
                .WithMany()
                .HasForeignKey(o => o.RestaurantId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<Order>()
                .HasOne(o => o.User)
                .WithMany()
                .HasForeignKey(o => o.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            // SEED DATA (Zengin Restoran ve Menü Listesi)
            modelBuilder.Entity<Restaurant>().HasData(
                new Restaurant { Id = 1, Name = "Gaziantep Kebapçısı", Description = "En lezzetli kebaplar ve lahmacunlar.", Address = "Çarşı Merkezi, No: 44", Rating = 4.8, LogoUrl = "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", CreatedAt = System.DateTime.Now, OwnerId = null },
                new Restaurant { Id = 2, Name = "İtalyan Pizza Dünyası", Description = "Gerçek odun ateşinde İtalyan pizzası.", Address = "Cumhuriyet Cad. No: 12", Rating = 4.5, LogoUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591", CreatedAt = System.DateTime.Now, OwnerId = null },
                new Restaurant { Id = 3, Name = "Dumanlı Burger", Description = "Gurme burger ve özel soslar.", Address = "Bahçelievler Mah. No: 7", Rating = 4.7, LogoUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd", CreatedAt = System.DateTime.Now, OwnerId = null },
                new Restaurant { Id = 4, Name = "Tatlı Köşesi", Description = "Geleneksel ve modern tatlılar.", Address = "Kanalboyu Cad. No: 21", Rating = 4.9, LogoUrl = "https://images.unsplash.com/photo-1551024601-bec78aea704b", CreatedAt = System.DateTime.Now, OwnerId = null },
                new Restaurant { Id = 5, Name = "Ege Deniz Restoran", Description = "Taze balık ve deniz mahsulleri.", Address = "Fahri Kayahan No: 88", Rating = 4.6, LogoUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2", CreatedAt = System.DateTime.Now, OwnerId = null },
                new Restaurant
                {
                    Id = 6,
                    Name = "Yeşil Bahçe",
                    Description = "Doğadan sofranıza taze sebze ve meyveler.",
                    Address = "Yeşilyurt Mah. Doğa Cad. No: 12",
                    LogoUrl = "https://images.unsplash.com/photo-1540420773420-3366772f4999",
                    Rating = 4.7,
                    CreatedAt = System.DateTime.Now,
                    OwnerId = null
                },
                new Restaurant
                {
                    Id = 7,
                    Name = "Malatya Ali Dayının Yeri",
                    Description = "Malatya'nın eşsiz lezzetleri, taze ve doğal ürünlerle Ali Dayı farkıyla.",
                    Address = "Kanalboyu Cad. No: 45, Malatya",
                    LogoUrl = "https://images.unsplash.com/photo-1626074353765-517a681e40be",
                    Rating = 4.9,
                    CreatedAt = System.DateTime.Now,
                    OwnerId = null
                },
                new Restaurant
                {
                    Id = 8,
                    Name = "Elazığ Kömürhan Kavurma",
                    Description = "Efsane Kömürhan kavurması ve Elazığ'ın yöresel et lezzetleri.",
                    Address = "Malatya-Elazığ Yolu, Kömürhan Mevkii",
                    LogoUrl = "https://images.unsplash.com/photo-1544025162-d76694265947",
                    Rating = 4.9,
                    CreatedAt = System.DateTime.Now,
                    OwnerId = null
                }
            );

            modelBuilder.Entity<MenuItem>().HasData(
                // KÖMÜRHAN KAVURMA MENÜSÜ
                new MenuItem { Id = 70, RestaurantId = 8, Name = "Kömürhan Kavurma", Description = "Kömürhan'ın dünyaca ünlü, lokum gibi kuzu kavurması.", Price = 1350, Category = "Spesiyaller", ImageUrl = "https://images.unsplash.com/photo-1603360946369-dc9bb6258143", IsInStock = true },
                new MenuItem { Id = 71, RestaurantId = 8, Name = "Kuzu Kafes", Description = "Bütün kuzu kafes, özel fırınlama tekniği ile.", Price = 4400, Category = "Spesiyaller", ImageUrl = "https://images.unsplash.com/photo-1544025162-d76694265947", IsInStock = true },
                new MenuItem { Id = 72, RestaurantId = 8, Name = "Kalbur Burma Kebap", Description = "Kalbur usulü fıstıklı ve özel zırh kıymalı.", Price = 1150, Category = "Spesiyaller", ImageUrl = "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", IsInStock = true },
                new MenuItem { Id = 73, RestaurantId = 8, Name = "Kiremitte Kaşarlı Kavurma", Description = "Fırında kaşar peyniri ile harmanlanmış kavurma.", Price = 1350, Category = "Spesiyaller", ImageUrl = "https://images.unsplash.com/photo-1603360946369-dc9bb6258143", IsInStock = true },
                new MenuItem { Id = 74, RestaurantId = 8, Name = "Fırın Beyti", Description = "Özel sos ve yoğurt eşliğinde fırınlanmış beyti.", Price = 920, Category = "Spesiyaller", ImageUrl = "https://images.unsplash.com/photo-1555396273-367ea4eb4db5", IsInStock = true },
                new MenuItem { Id = 75, RestaurantId = 8, Name = "Adana Kebap", Description = "Klasik Adana lezzeti, közlenmiş sebzelerle.", Price = 750, Category = "Kebaplar", ImageUrl = "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", IsInStock = true },
                new MenuItem { Id = 76, RestaurantId = 8, Name = "Küşleme", Description = "Kuzunun en özel ve yumuşak yeri.", Price = 1340, Category = "Kırmızı Etler", ImageUrl = "https://images.unsplash.com/photo-1544025162-d76694265947", IsInStock = true },
                new MenuItem { Id = 77, RestaurantId = 8, Name = "Şefin Salatası", Description = "Taptaze mevsim sebzeleri ve özel şef sosu.", Price = 500, Category = "Salatalar", ImageUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd", IsInStock = true },
                new MenuItem { Id = 78, RestaurantId = 8, Name = "Muhammara", Description = "Cevizli ve nar ekşili nefis meze.", Price = 330, Category = "Mezeler", ImageUrl = "https://images.unsplash.com/photo-1541529086526-db283c563270", IsInStock = true },
                new MenuItem { Id = 79, RestaurantId = 8, Name = "Yayık Ayran", Description = "Bol köpüklü, doğal yayık ayranı.", Price = 60, Category = "İçecekler", ImageUrl = "https://images.unsplash.com/photo-1571328003758-4a3921661709", IsInStock = true },

                // ALİ DAYI MALATYA MENÜSÜ
                new MenuItem { Id = 51, RestaurantId = 7, Name = "1.5 Karışık Izgara", Description = "Tavuk, Kıyma, Kuşbaşı etlerinin muhteşem buluşması.", Price = 1125, Category = "Ana Yemekler", ImageUrl = "https://images.unsplash.com/photo-1626074353765-517a681e40be", IsInStock = true },
                new MenuItem { Id = 52, RestaurantId = 7, Name = "Kiremitte Kaşarlı Alabalık", Description = "Fırında taze alabalık, üzerine erimiş kaşar peyniri.", Price = 410, Category = "Ana Yemekler", ImageUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2", IsInStock = true },
                new MenuItem { Id = 53, RestaurantId = 7, Name = "Adana Kebap (Tek Şiş)", Description = "Özel baharatlarla hazırlanan zırh kıyması.", Price = 230, Category = "Ana Yemekler", ImageUrl = "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", IsInStock = true },
                new MenuItem { Id = 54, RestaurantId = 7, Name = "Kuşbaşı Kebap (Tek Şiş)", Description = "Lokum gibi kuzu kuşbaşı.", Price = 250, Category = "Ana Yemekler", ImageUrl = "https://images.unsplash.com/photo-1544025162-d76694265947", IsInStock = true },
                new MenuItem { Id = 55, RestaurantId = 7, Name = "Balık Dürüm", Description = "Taze balık eti, yeşillik ve özel sos ile.", Price = 250, Category = "Ana Yemekler", ImageUrl = "https://images.unsplash.com/photo-1554522723-b2a47cb105e3", IsInStock = true },
                new MenuItem { Id = 56, RestaurantId = 7, Name = "Mercimek Çorbası", Description = "Sıcacık, ev yapımı tadında.", Price = 130, Category = "Çorbalar", ImageUrl = "https://images.unsplash.com/photo-1547592166-23ac45744acd", IsInStock = true },
                new MenuItem { Id = 57, RestaurantId = 7, Name = "Fırın Helva", Description = "Sıcak servis edilen enfes tahin helvası.", Price = 150, Category = "Tatlılar", ImageUrl = "https://images.unsplash.com/photo-1579372781875-66bbaf22c702", IsInStock = true },
                new MenuItem { Id = 58, RestaurantId = 7, Name = "Künefe", Description = "Bol peynirli, çıtır çıtır.", Price = 200, Category = "Tatlılar", ImageUrl = "https://images.unsplash.com/photo-1571115177098-24ec42ed2bb4", IsInStock = true },
                new MenuItem { Id = 59, RestaurantId = 7, Name = "Yayık Ayran", Description = "Buz gibi, bol köpüklü.", Price = 35, Category = "İçecekler", ImageUrl = "https://images.unsplash.com/photo-1571328003758-4a3921661709", IsInStock = true },
                new MenuItem { Id = 60, RestaurantId = 7, Name = "Türk Kahvesi", Description = "Közde ağır ağır pişmiş.", Price = 80, Category = "İçecekler", ImageUrl = "https://images.unsplash.com/photo-1544787210-22bb1e8163ee", IsInStock = true },

                // Mevcut Menüler...
                new MenuItem { Id = 1, RestaurantId = 1, Name = "Adana Kebap", Description = "Zırh kıyması, közlenmiş biber ile.", Price = 250, DiscountPrice = 200, Category = "Kebap", ImageUrl = "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500", IsInStock = true },
                new MenuItem { Id = 2, RestaurantId = 1, Name = "Lahmacun", Description = "Çıtır Antep lahmacunu.", Price = 80, DiscountPrice = 65, Category = "Kebap", ImageUrl = "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500", IsInStock = true },
                // Pizza (ID: 3-4)
                new MenuItem { Id = 3, RestaurantId = 2, Name = "Margarita Pizza", Description = "Mozzarella ve taze fesleğen.", Price = 180, DiscountPrice = 149, Category = "Pizza", ImageUrl = "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=500", IsInStock = true },
                new MenuItem { Id = 4, RestaurantId = 2, Name = "Karışık Pizza", Description = "Bol malzemeli İtalyan usulü.", Price = 220, DiscountPrice = 190, Category = "Pizza", ImageUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", IsInStock = true },
                // Burger (ID: 5-6)
                new MenuItem { Id = 5, RestaurantId = 3, Name = "Classic Burger", Description = "180gr köfte ve cheddar.", Price = 220, DiscountPrice = 199, Category = "Burger", ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", IsInStock = true },
                new MenuItem { Id = 6, RestaurantId = 3, Name = "Dumanlı Special", Description = "Özel soslu dev burger.", Price = 280, DiscountPrice = 240, Category = "Burger", ImageUrl = "https://images.unsplash.com/photo-1550547660-d9450f859349?w=500", IsInStock = true },
                // Tatlı (ID: 7-8)
                new MenuItem { Id = 7, RestaurantId = 4, Name = "Fıstıklı Baklava", Description = "Gaziantep usulü bol fıstıklı.", Price = 150, DiscountPrice = 120, Category = "Tatlı", ImageUrl = "https://images.unsplash.com/photo-1519676867240-f03562e64548?w=500", IsInStock = true },
                new MenuItem { Id = 8, RestaurantId = 4, Name = "Sütlaç", Description = "Fırınlanmış tam kıvamında.", Price = 70, Category = "Tatlı", ImageUrl = "https://images.unsplash.com/photo-1516684732162-798a0062be99?w=500", IsInStock = true },
                // Deniz Mahsulleri (ID: 9)
                new MenuItem { Id = 9, RestaurantId = 5, Name = "Izgara Çupra", Description = "Salata ve garnitür ile.", Price = 350, DiscountPrice = 290, Category = "Deniz Mahsulleri", ImageUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500", IsInStock = true },
                // Yeşil Bahçe (ID: 10)
                new MenuItem { Id = 10, RestaurantId = 6, Name = "Kinoa Salatası", Description = "Sağlıklı ve doyurucu.", Price = 120, Category = "Yeşil Bahçe", ImageUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500", IsInStock = true }
            );
        }
    }
}
