using System;

namespace YemekSiparisi.Api.Models
{
    public class MenuItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public decimal? DiscountPrice { get; set; }
        public string ImageUrl { get; set; }
        public string Category { get; set; }
        public bool IsInStock { get; set; } = true;

        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
    }
}
