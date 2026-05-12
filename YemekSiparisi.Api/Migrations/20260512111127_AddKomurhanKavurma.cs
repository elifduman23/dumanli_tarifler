using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace YemekSiparisi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddKomurhanKavurma : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5099), "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5115), "https://images.unsplash.com/photo-1513104890138-7c749659a591" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5118), "https://images.unsplash.com/photo-1568901346375-23c9450c58cd" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5121), "https://images.unsplash.com/photo-1551024601-bec78aea704b" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5125), "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5127));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5131));

            migrationBuilder.InsertData(
                table: "Restaurants",
                columns: new[] { "Id", "Address", "CreatedAt", "Description", "LogoUrl", "Name", "OwnerId", "Rating" },
                values: new object[] { 8, "Malatya-Elazığ Yolu, Kömürhan Mevkii", new DateTime(2026, 5, 12, 14, 11, 26, 413, DateTimeKind.Local).AddTicks(5133), "Efsane Kömürhan kavurması ve Elazığ'ın yöresel et lezzetleri.", "https://images.unsplash.com/photo-1544025162-d76694265947", "Elazığ Kömürhan Kavurma", null, 4.9000000000000004 });

            migrationBuilder.InsertData(
                table: "MenuItems",
                columns: new[] { "Id", "Category", "Description", "DiscountPrice", "ImageUrl", "IsInStock", "Name", "Price", "RestaurantId" },
                values: new object[,]
                {
                    { 70, "Spesiyaller", "Kömürhan'ın dünyaca ünlü, lokum gibi kuzu kavurması.", null, "https://images.unsplash.com/photo-1603360946369-dc9bb6258143", true, "Kömürhan Kavurma", 1350m, 8 },
                    { 71, "Spesiyaller", "Bütün kuzu kafes, özel fırınlama tekniği ile.", null, "https://images.unsplash.com/photo-1544025162-d76694265947", true, "Kuzu Kafes", 4400m, 8 },
                    { 72, "Spesiyaller", "Kalbur usulü fıstıklı ve özel zırh kıymalı.", null, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", true, "Kalbur Burma Kebap", 1150m, 8 },
                    { 73, "Spesiyaller", "Fırında kaşar peyniri ile harmanlanmış kavurma.", null, "https://images.unsplash.com/photo-1603360946369-dc9bb6258143", true, "Kiremitte Kaşarlı Kavurma", 1350m, 8 },
                    { 74, "Spesiyaller", "Özel sos ve yoğurt eşliğinde fırınlanmış beyti.", null, "https://images.unsplash.com/photo-1555396273-367ea4eb4db5", true, "Fırın Beyti", 920m, 8 },
                    { 75, "Kebaplar", "Klasik Adana lezzeti, közlenmiş sebzelerle.", null, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0", true, "Adana Kebap", 750m, 8 },
                    { 76, "Kırmızı Etler", "Kuzunun en özel ve yumuşak yeri.", null, "https://images.unsplash.com/photo-1544025162-d76694265947", true, "Küşleme", 1340m, 8 },
                    { 77, "Salatalar", "Taptaze mevsim sebzeleri ve özel şef sosu.", null, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd", true, "Şefin Salatası", 500m, 8 },
                    { 78, "Mezeler", "Cevizli ve nar ekşili nefis meze.", null, "https://images.unsplash.com/photo-1541529086526-db283c563270", true, "Muhammara", 330m, 8 },
                    { 79, "İçecekler", "Bol köpüklü, doğal yayık ayranı.", null, "https://images.unsplash.com/photo-1571328003758-4a3921661709", true, "Yayık Ayran", 60m, 8 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 70);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 71);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 72);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 73);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 74);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 75);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 76);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 77);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 78);

            migrationBuilder.DeleteData(
                table: "MenuItems",
                keyColumn: "Id",
                keyValue: 79);

            migrationBuilder.DeleteData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6523), "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6539), "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6542), "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6545), "https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "CreatedAt", "LogoUrl" },
                values: new object[] { new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6548), "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500" });

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 6,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6551));

            migrationBuilder.UpdateData(
                table: "Restaurants",
                keyColumn: "Id",
                keyValue: 7,
                column: "CreatedAt",
                value: new DateTime(2026, 5, 12, 13, 44, 15, 6, DateTimeKind.Local).AddTicks(6554));
        }
    }
}
