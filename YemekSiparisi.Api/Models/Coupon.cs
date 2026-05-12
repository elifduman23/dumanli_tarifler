using System;

namespace YemekSiparisi.Api.Models
{
    public class Coupon
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public string DiscountType { get; set; } // "Percentage" (Yüzde) veya "Flat" (Sabit Tutar)
        public decimal DiscountValue { get; set; }
        public bool IsUsed { get; set; } = false;
        
        public int UserId { get; set; }
        public User User { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
