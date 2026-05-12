using System;
using System.Collections.Generic;

namespace YemekSiparisi.Api.Models
{
    public class Order
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }

        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }

        public decimal TotalAmount { get; set; }
        public string Status { get; set; } // Örn: "Hazırlanıyor", "Yolda", "Teslim Edildi"
        
        public List<OrderItem> OrderItems { get; set; }
        public DateTime OrderDate { get; set; } = DateTime.UtcNow;
    }

    public class OrderItem
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public Order Order { get; set; }

        public int MenuItemId { get; set; }
        public MenuItem MenuItem { get; set; }

        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }
}
