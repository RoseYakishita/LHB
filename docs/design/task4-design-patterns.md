# Task 4 - Design Patterns áp dụng

1. **Repository Pattern**
   - Tách truy vấn DB khỏi business logic.

2. **Service Layer Pattern**
   - Gom nghiệp vụ vào `AuthService`, `ProductService`, `OrderService`, `ChatbotService`.

3. **DTO + Validation Pattern**
   - Chuẩn hóa và kiểm tra dữ liệu đầu vào API.

4. **Strategy Pattern**
   - Linh hoạt xử lý nhiều phương thức thanh toán/chatbot provider.

5. **Factory Pattern**
   - Tạo Strategy phù hợp theo cấu hình runtime.

6. **Adapter Pattern**
   - Chuẩn hóa tích hợp dịch vụ ngoài (OpenAI, VNPay...).

7. **Observer/Event Pattern**
   - Xử lý hậu sự kiện: tạo đơn, thanh toán thành công, cập nhật tồn kho.

Mục tiêu: mã nguồn dễ mở rộng, dễ bảo trì, tách trách nhiệm rõ ràng.
