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
                
            modelBuilder.Entity<Order>()
                .Property(o => o.TotalAmount)
                .HasColumnType("decimal(18,2)");
                
            modelBuilder.Entity<OrderItem>()
                .Property(oi => oi.UnitPrice)
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
            modelBuilder.Entity<Restaurant>().HasData(
                new Restaurant { Id = 1, Name = "Gaziantep Kebapçısı", Description = "En lezzetli kebaplar ve lahmacunlar.", Address = "Çarşı Merkezi, No: 44", Rating = 4.8, LogoUrl = "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500", CreatedAt = System.DateTime.Now, OwnerId = 0 },
                new Restaurant { Id = 2, Name = "İtalyan Pizza Dünyası", Description = "Gerçek odun ateşinde İtalyan pizzası.", Address = "Cumhuriyet Cad. No: 12", Rating = 4.5, LogoUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", CreatedAt = System.DateTime.Now, OwnerId = 0 },
                new Restaurant { Id = 3, Name = "Dumanlı Burger", Description = "Gurme burger ve özel soslar.", Address = "Bahçelievler Mah. No: 7", Rating = 4.7, LogoUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", CreatedAt = System.DateTime.Now, OwnerId = 0 }
            );

            modelBuilder.Entity<MenuItem>().HasData(
                new MenuItem { Id = 1, RestaurantId = 1, Name = "Adana Kebap", Description = "Zırh kıyması, közlenmiş biber ve domates ile.", Price = 250, Category = "Kebap", ImageUrl = "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500", IsInStock = true },
                new MenuItem { Id = 2, RestaurantId = 1, Name = "Lahmacun", Description = "Bol malzemeli çıtır Antep lahmacunu.", Price = 80, Category = "Kebap", ImageUrl = "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500", IsInStock = true },
                new MenuItem { Id = 3, RestaurantId = 2, Name = "Margarita Pizza", Description = "Mozzarella, taze fesleğen ve domates sosu.", Price = 180, Category = "Pizza", ImageUrl = "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=500", IsInStock = true },
                new MenuItem { Id = 4, RestaurantId = 3, Name = "Classic Burger", Description = "180gr köfte, karamelize soğan ve cheddar.", Price = 220, Category = "Burger", ImageUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", IsInStock = true }
            );
        }
    }
}
