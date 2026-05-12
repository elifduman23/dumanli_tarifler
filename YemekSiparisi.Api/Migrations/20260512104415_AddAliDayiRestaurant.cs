using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace YemekSiparisi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddAliDayiRestaurant : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6523));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6539));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6542));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6545));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6548));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "Address", "CreatedAt", "Description", "LogoUrl", "Rating" },
                values: new object[] { "Yeşilyurt Mah. Doğa Cad. No: 12", new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6551), "Doğadan sofranıza taze sebze ve meyveler.", "https://images.unsplash.com/photo-1540420773420-3366772f4999", 4.7000000000000002 });

            migrationBuilder.InsertData(
                table: "Restaurants",
                columns: new[] { "Id", "Address", "CreatedAt", "Description", "LogoUrl", "Name", "OwnerId", "Rating" },
                values: new object[] { 7, "Kanalboyu Cad. No: 45, Malatya", new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6554), "Malatya'nın eşsiz lezzetleri, taze ve doğal ürünlerle Ali Dayı farkıyla.", "https://images.unsplash.com/photo-1626074353765-517a681e40be", "Malatya Ali Dayının Yeri", null, 4.9000000000000004 });

            migrationBuilder.InsertData(
                table: "MenuItems",
                columns: new[] { "Id", "Category", "Description", "DiscountPrice", "ImageUrl", "IsInStock", "Name", "Price", "RestaurantId" },
                values: new object[,]
                {
                    { 51, "Ana Yemekler", "Tavuk, Kıyma, Kuşbaşı etlerinin muhteşem buluşması.", null, "https://images.unsplash.com/photo-1626074353765-517a681e40be", true, "1.5 Karışık Izgara", 1125m, 7 },
                    { 52, "Ana Yemekler", "Fırında taze alabalık, üzerine erimiş kaşar peyniri.", null, "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2", true, "Kiremitte Kaşarlı Alabalık", 410m, 7 },
                    { 53, "Ana Yemekler", "Özel baharatlarla hazırlanan zırh kıyması.", null, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", true, "Adana Kebap (Tek Şiş)", 230m, 7 },
                    { 54, "Ana Yemekler", "Lokum gibi kuzu kuşbaşı.", null, "https://images.unsplash.com/photo-1544025162-d76694265947", true, "Kuşbaşı Kebap (Tek Şiş)", 250m, 7 },
                    { 55, "Ana Yemekler", "Taze balık eti, yeşillik ve özel sos ile.", null, "https://images.unsplash.com/photo-1554522723-b2a47cb105e3", true, "Balık Dürüm", 250m, 7 },
                    { 56, "Çorbalar", "Sıcacık, ev yapımı tadında.", null, "https://images.unsplash.com/photo-1547592166-23ac45744acd", true, "Mercimek Çorbası", 130m, 7 },
                    { 57, "Tatlılar", "Sıcak servis edilen enfes tahin helvası.", null, "https://images.unsplash.com/photo-1579372781875-66bbaf22c702", true, "Fırın Helva", 150m, 7 },
                    { 58, "Tatlılar", "Bol peynirli, çıtır çıtır.", null, "https://images.unsplash.com/photo-1571115177098-24ec42ed2bb4", true, "Künefe", 200m, 7 },
                    { 59, "İçecekler", "Buz gibi, bol köpüklü.", null, "https://images.unsplash.com/photo-1571328003758-4a3921661709", true, "Yayık Ayran", 35m, 7 },
                    { 60, "İçecekler", "Közde ağır ağır pişmiş.", null, "https://images.unsplash.com/photo-1544787210-22bb1e8163ee", true, "Türk Kahvesi", 80m, 7 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 51);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 52);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 53);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 54);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 55);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 56);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 57);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 58);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 59);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 60);

            migrationBuilder.DeleteData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 1,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 18, 7, 570, DateTimeKind.Local).AddTicks(761));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 2,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 18, 7, 570, DateTimeKind.Local).AddTicks(776));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 3,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 18, 7, 570, DateTimeKind.Local).AddTicks(779));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 4,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 18, 7, 570, DateTimeKind.Local).AddTicks(782));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 5,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 18, 7, 570, DateTimeKind.Local).AddTicks(785));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "Address", "CreatedAt", "Description", "LogoUrl", "Rating" },
                values: new object[] { "İnönü Cad. No: 156", new DateTime(2026, 5, 12, 13, 18, 7, 570, DateTimeKind.Local).AddTicks(788), "Sağlıklı salatalar ve vegan seçenekler.", "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500", 4.4000000000000004 });
        }
    }
}
