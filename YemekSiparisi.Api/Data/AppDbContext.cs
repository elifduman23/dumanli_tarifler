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

            // SEED DATA (Hoca için hazır veriler)
            // Not: Once kullaniciyi ekliyoruz ki restoranlar ona baglanabilsin.
            modelBuilder.Entity<User>().HasData(
                new User 
                { 
                    Id = 1, 
                    FullName = "Sistem Yöneticisi", 
                    Email = "admin@dumanli.com", 
                    PasswordHash = "AQAAAAEAACcQAAAAEJ3y...", // admin123 hashed
                    Role = "Admin",
                    Province = "Malatya",
                    District = "Battalgazi",
                    Neighborhood = "Üniversite"
                }
            );

            modelBuilder.Entity<Restaurant>().HasData(
                new Restaurant { Id = 1, Name = "Gaziantep Kebapçısı", Description = "En lezzetli kebaplar ve lahmacunlar.", Address = "Çarşı Merkezi, No: 44", Rating = 4.8, LogoUrl = "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500", CreatedAt = System.DateTime.Now, OwnerId = 1 },
                new Restaurant { Id = 2, Name = "İtalyan Pizza Dünyası", Description = "Gerçek odun ateşinde İtalyan pizzası.", Address = "Cumhuriyet Cad. No: 12", Rating = 4.5, LogoUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", CreatedAt = System.DateTime.Now, OwnerId = 1 },
                new Restaurant { Id = 3, Name = "Dumanlı Burger", Description = "Gurme burger ve özel soslar.", Address = "Bahçelievler Mah. No: 7", Rating = 4.7, LogoUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", CreatedAt = System.DateTime.Now, OwnerId = 1 },
                new Restaurant { Id = 4, Name = "Tatlı Köşesi", Description = "Geleneksel ve modern tatlılar.", Address = "Kanalboyu Cad. No: 21", Rating = 4.9, LogoUrl = "https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500", CreatedAt = System.DateTime.Now, OwnerId = 1 },
                new Restaurant { Id = 5, Name = "Ege Deniz Restoran", Description = "Taze balık ve deniz mahsulleri.", Address = "Fahri Kayahan No: 88", Rating = 4.6, LogoUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500", CreatedAt = System.DateTime.Now, OwnerId = 1 },
                new Restaurant { Id = 6, Name = "Yeşil Bahçe", Description = "Sağlıklı salatalar ve vegan seçenekler.", Address = "İnönü Cad. No: 156", Rating = 4.4, LogoUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500", CreatedAt = System.DateTime.Now, OwnerId = 1 }
            );

            modelBuilder.Entity<MenuItem>().HasData(
                // Kebapçı (ID: 1-2)
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
