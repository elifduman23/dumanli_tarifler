using System;

namespace YemekSiparisi.Api.Models
{
    public class User
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        
        // Rolleri basit tutmak için string olarak tanımlayabiliriz: "Admin", "RestaurantOwner", "Customer"
        public string Role { get; set; }
        
        public string? Province { get; set; }
        public string? District { get; set; }
        public string? Neighborhood { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
