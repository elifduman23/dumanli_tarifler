using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace YemekSiparisi.Api.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Role = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Province = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    District = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Neighborhood = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Coupons",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Code = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DiscountType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DiscountValue = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    IsUsed = table.Column<bool>(type: "bit", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Coupons", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Coupons_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Restaurants",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LogoUrl = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Rating = table.Column<double>(type: "float", nullable: false),
                    OwnerId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Restaurants", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Restaurants_Users_OwnerId",
                        column: x => x.OwnerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Favorites",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RestaurantId = table.Column<int>(type: "int", nullable: false),
                    AddedDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Favorites", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Favorites_Restaurants_RestaurantId",
                        column: x => x.RestaurantId,
                        principalTable: "Restaurants",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Favorites_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "MenuItems",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    DiscountPrice = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    ImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Category = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsInStock = table.Column<bool>(type: "bit", nullable: false),
                    RestaurantId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MenuItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MenuItems_Restaurants_RestaurantId",
                        column: x => x.RestaurantId,
                        principalTable: "Restaurants",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Orders",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RestaurantId = table.Column<int>(type: "int", nullable: false),
                    TotalAmount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OrderDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Orders", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Orders_Restaurants_RestaurantId",
                        column: x => x.RestaurantId,
                        principalTable: "Restaurants",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "OrderItems",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OrderId = table.Column<int>(type: "int", nullable: false),
                    MenuItemId = table.Column<int>(type: "int", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    UnitPrice = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrderItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OrderItems_MenuItems_MenuItemId",
                        column: x => x.MenuItemId,
                        principalTable: "MenuItems",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OrderItems_Orders_OrderId",
                        column: x => x.OrderId,
                        principalTable: "Orders",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "District", "Email", "FullName", "Neighborhood", "PasswordHash", "Province", "Role" },
                values: new object[] { 1, new DateTime(2026, 5, 12, 10, 2, 59, 95, DateTimeKind.Utc).AddTicks(1400), "Battalgazi", "admin@dumanli.com", "Sistem Yöneticisi", "Üniversite", "AQAAAAEAACcQAAAAEJ3y...", "Malatya", "Admin" });

            migrationBuilder.InsertData(
                table: "Restaurants",
                columns: new[] { "Id", "Address", "CreatedAt", "Description", "LogoUrl", "Name", "OwnerId", "Rating" },
                values: new object[,]
                {
                    { 1, "Çarşı Merkezi, No: 44", new DateTime(2026, 5, 12, 13, 2, 59, 95, DateTimeKind.Local).AddTicks(1873), "En lezzetli kebaplar ve lahmacunlar.", "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500", "Gaziantep Kebapçısı", 1, 4.7999999999999998 },
                    { 2, "Cumhuriyet Cad. No: 12", new DateTime(2026, 5, 12, 13, 2, 59, 95, DateTimeKind.Local).AddTicks(1896), "Gerçek odun ateşinde İtalyan pizzası.", "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", "İtalyan Pizza Dünyası", 1, 4.5 },
                    { 3, "Bahçelievler Mah. No: 7", new DateTime(2026, 5, 12, 13, 2, 59, 95, DateTimeKind.Local).AddTicks(1900), "Gurme burger ve özel soslar.", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", "Dumanlı Burger", 1, 4.7000000000000002 },
                    { 4, "Kanalboyu Cad. No: 21", new DateTime(2026, 5, 12, 13, 2, 59, 95, DateTimeKind.Local).AddTicks(1904), "Geleneksel ve modern tatlılar.", "https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500", "Tatlı Köşesi", 1, 4.9000000000000004 },
                    { 5, "Fahri Kayahan No: 88", new DateTime(2026, 5, 12, 13, 2, 59, 95, DateTimeKind.Local).AddTicks(1907), "Taze balık ve deniz mahsulleri.", "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500", "Ege Deniz Restoran", 1, 4.5999999999999996 },
                    { 6, "İnönü Cad. No: 156", new DateTime(2026, 5, 12, 13, 2, 59, 95, DateTimeKind.Local).AddTicks(1911), "Sağlıklı salatalar ve vegan seçenekler.", "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500", "Yeşil Bahçe", 1, 4.4000000000000004 }
                });

            migrationBuilder.InsertData(
                table: "MenuItems",
                columns: new[] { "Id", "Category", "Description", "DiscountPrice", "ImageUrl", "IsInStock", "Name", "Price", "RestaurantId" },
                values: new object[,]
                {
                    { 1, "Kebap", "Zırh kıyması, közlenmiş biber ile.", 200m, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500", true, "Adana Kebap", 250m, 1 },
                    { 2, "Kebap", "Çıtır Antep lahmacunu.", 65m, "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500", true, "Lahmacun", 80m, 1 },
                    { 3, "Pizza", "Mozzarella ve taze fesleğen.", 149m, "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=500", true, "Margarita Pizza", 180m, 2 },
                    { 4, "Pizza", "Bol malzemeli İtalyan usulü.", 190m, "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", true, "Karışık Pizza", 220m, 2 },
                    { 5, "Burger", "180gr köfte ve cheddar.", 199m, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500", true, "Classic Burger", 220m, 3 },
                    { 6, "Burger", "Özel soslu dev burger.", 240m, "https://images.unsplash.com/photo-1550547660-d9450f859349?w=500", true, "Dumanlı Special", 280m, 3 },
                    { 7, "Tatlı", "Gaziantep usulü bol fıstıklı.", 120m, "https://images.unsplash.com/photo-1519676867240-f03562e64548?w=500", true, "Fıstıklı Baklava", 150m, 4 },
                    { 8, "Tatlı", "Fırınlanmış tam kıvamında.", null, "https://images.unsplash.com/photo-1516684732162-798a0062be99?w=500", true, "Sütlaç", 70m, 4 },
                    { 9, "Deniz Mahsulleri", "Salata ve garnitür ile.", 290m, "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500", true, "Izgara Çupra", 350m, 5 },
                    { 10, "Yeşil Bahçe", "Sağlıklı ve doyurucu.", null, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500", true, "Kinoa Salatası", 120m, 6 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Coupons_UserId",
                table: "Coupons",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Favorites_RestaurantId",
                table: "Favorites",
                column: "RestaurantId");

            migrationBuilder.CreateIndex(
                name: "IX_Favorites_UserId",
                table: "Favorites",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_MenuItems_RestaurantId",
                table: "MenuItems",
                column: "RestaurantId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_MenuItemId",
                table: "OrderItems",
                column: "MenuItemId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_OrderId",
                table: "OrderItems",
                column: "OrderId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_RestaurantId",
                table: "Orders",
                column: "RestaurantId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_UserId",
                table: "Orders",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Restaurants_OwnerId",
                table: "Restaurants",
                column: "OwnerId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Coupons");

            migrationBuilder.DropTable(
                name: "Favorites");

            migrationBuilder.DropTable(
                name: "OrderItems");

            migrationBuilder.DropTable(
                name: "MenuItems");

            migrationBuilder.DropTable(
                name: "Orders");

            migrationBuilder.DropTable(
                name: "Restaurants");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
