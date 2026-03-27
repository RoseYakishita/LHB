# Task 1 - Chọn kiến trúc và System Architecture Diagram

## Kiến trúc chọn
Modular Monolith (NestJS) cho môi trường local.

## Lý do
- Dễ triển khai, dễ demo, chi phí thấp
- Phù hợp quy mô đồ án và 50 users đồng thời
- Dễ mở rộng sau này

## Mermaid Diagram
```mermaid
flowchart TD
    U[User - Browser] --> FE[Frontend React + Vite :5173]
    FE --> API[NestJS API :3000]

    API --> AUTH[Auth Module]
    API --> PROD[Product Module]
    API --> CART[Cart Module]
    API --> ORD[Order Module]
    API --> PAY[Payment Module]
    API --> CHAT[Chatbot Module]

    CHAT --> AI[OpenAI API / Mock AI]

    AUTH --> DB[(MySQL Local :3306)]
    PROD --> DB
    CART --> DB
    ORD --> DB
    PAY --> DB
    CHAT --> DB
```
