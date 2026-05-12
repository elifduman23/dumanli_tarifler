using System;
using System.ComponentModel.DataAnnotations;

namespace YemekSiparisi.Api.Models
{
    public class Favorite
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }

        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        
        public DateTime AddedDate { get; set; } = DateTime.UtcNow;
    }
}
