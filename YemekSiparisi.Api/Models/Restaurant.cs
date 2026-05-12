using System;
using System.Collections.Generic;

namespace YemekSiparisi.Api.Models
{
    public class Restaurant
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Address { get; set; }
        public string LogoUrl { get; set; }
        public double Rating { get; set; } = 0.0;
        
        public int? OwnerId { get; set; }
        public User? Owner { get; set; }
        
        public List<MenuItem> MenuItems { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
