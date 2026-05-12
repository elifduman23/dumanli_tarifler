using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace YemekSiparisi.Api.Migrations
{
    /// <inheritdoc />
    public partial class SeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "District", "Email", "FullName", "Neighborhood", "PasswordHash", "Province", "Role" },
                values: new object[] { 1, new DateTime(2026, 5, 12, 9, 53, 35, 222, DateTimeKind.Utc).AddTicks(3959), "Battalgazi", "admin@dumanli.com", "Sistem Yöneticisi", "Üniversite", "AQAAAAEAACcQAAAAEJ3y...", "Malatya", "Admin" });

            migrationBuilder.InsertData(
                table: "Restaurants",
                columns: new[] { "Id", "Address", "CreatedAt", "Description", "LogoUrl", "Name", "OwnerId", "Rating" },
                values: new object[,]
                {
                    { 1, "Çarşı Merkezi, No: 44", new DateTime(2026, 5, 12, 12, 53, 35, 222, DateTimeKind.Local).AddTicks(4272), "En lezzetli kebaplar ve lahmacunlar.", "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500", "Gaziantep Kebapçısı", 1, 4.7999999999999998 },
                    { 2, "Cumhuriyet Cad. No: 12", new DateTime(2026, 5, 12, 12, 53, 35, 222, DateTimeKind.Local).AddTicks(4290), "Gerçek odun ateşinde İtalyan pizzası.", "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", "İtalyan Pizza Dünyası", 1, 4.5 },
                    { 3, "Bahçelievler Mah. No: 7", new DateTime(2026, 5, 12, 12, 53, 35, 222, DateTimeKind.Local).AddTicks(4293), "Gurme burger ve özel soslar.", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", "Dumanlı Burger", 1, 4.7000000000000002 }
                });

            migrationBuilder.InsertData(
                table: "MenuItems",
                columns: new[] { "Id", "Category", "Description", "DiscountPrice", "ImageUrl", "IsInStock", "Name", "Price", "RestaurantId" },
                values: new object[,]
                {
                    { 1, "Kebap", "Zırh kıyması, közlenmiş biber ve domates ile.", 200m, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500", true, "Adana Kebap", 250m, 1 },
                    { 2, "Kebap", "Bol malzemeli çıtır Antep lahmacunu.", 65m, "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500", true, "Lahmacun", 80m, 1 },
                    { 3, "Pizza", "Mozzarella, taze fesleğen ve domates sosu.", 149m, "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=500", true, "Margarita Pizza", 180m, 2 },
                    { 4, "Burger", "180gr köfte, karamelize soğan ve cheddar.", 199m, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", true, "Classic Burger", 220m, 3 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1);
        }
    }
}
