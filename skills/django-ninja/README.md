# Django Ninja Project Standard - 使用示例

这是 `django-ninja-project-standard` skill 的参考实现和最佳实践。

## 何时使用

✅ **应该使用：**
- 创建新的 Django Ninja API 项目
- 改造现有 Django 项目为标准结构
- 审查 Django Ninja 项目是否符合规范
- 团队协作，需要统一项目结构

❌ **不适用：**
- Django REST Framework 项目（不同框架）
- 非 API 的 Django 项目（如传统 MVT）
- Flask / FastAPI 项目

## 标准技术栈

```
核心框架:
- Django 5.0+
- Django Ninja 1.0+

数据层:
- PostgreSQL 15+
- Redis 7+ (缓存和 Celery broker)

任务队列:
- Celery 5+

工具链:
- uv (包管理)
- Docker + Docker Compose (开发环境)
- pytest (测试)
```

## 标准目录结构

```
project-root/
├── backend/                    # Django 应用代码
│   ├── manage.py
│   ├── apps/                   # 业务应用
│   │   ├── common/             # 公共基础设施
│   │   │   ├── middleware.py
│   │   │   ├── exceptions.py
│   │   │   └── responses.py
│   │   └── users/              # 用户模块示例
│   │       ├── models.py
│   │       ├── schemas.py      # Pydantic models
│   │       ├── services.py     # 业务逻辑
│   │       ├── repositories.py # 数据访问
│   │       └── api.py          # API endpoints
│   └── config/                 # 项目配置
│       ├── settings.py
│       ├── urls.py             # 主路由入口
│       └── celery.py
│
├── tests/                      # 测试代码
│   ├── unit/
│   └── integration/
│
├── docker/                     # Docker 配置
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── .env.example               # 环境变量模板
├── pyproject.toml             # 项目依赖 (uv)
└── README.md
```

## API 规范

### 统一入口

```python
# config/urls.py
from django.urls import path
from ninja import NinjaAPI

api = NinjaAPI(
    title="Project API",
    version="1.0.0",
    docs_url="/docs",
)

# 注册各模块 router
from apps.users.api import router as users_router
api.add_router("/users/", users_router, tags=["Users"])

urlpatterns = [
    path("api/", api.urls),
    path("health/", health_check),
]
```

### 统一响应格式

```python
# apps/common/responses.py
from typing import Generic, TypeVar
from pydantic import BaseModel

T = TypeVar("T")

class SuccessResponse(BaseModel, Generic[T]):
    success: bool = True
    data: T
    
class ErrorResponse(BaseModel):
    success: bool = False
    error: str
    code: str

# 使用
@router.get("/users/{user_id}", response=SuccessResponse[UserSchema])
def get_user(request, user_id: int):
    user = user_service.get_user(user_id)
    return SuccessResponse(data=user)
```

### 分层架构

```python
# apps/users/models.py - 数据模型
from django.db import models

class User(models.Model):
    username = models.CharField(max_length=50, unique=True)
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)

# apps/users/schemas.py - API 模型
from pydantic import BaseModel, EmailStr

class UserSchema(BaseModel):
    id: int
    username: str
    email: EmailStr
    
class CreateUserRequest(BaseModel):
    username: str
    email: EmailStr
    password: str

# apps/users/repositories.py - 数据访问
class UserRepository:
    def find_by_id(self, user_id: int) -> User | None:
        return User.objects.filter(id=user_id).first()
    
    def save(self, user: User) -> User:
        user.save()
        return user

# apps/users/services.py - 业务逻辑
class UserService:
    def __init__(self, repository: UserRepository):
        self._repository = repository
    
    def get_user(self, user_id: int) -> UserSchema:
        user = self._repository.find_by_id(user_id)
        if not user:
            raise UserNotFoundError()
        return UserSchema.from_orm(user)

# apps/users/api.py - API endpoints
from ninja import Router

router = Router()

@router.get("/{user_id}", response=UserSchema)
def get_user(request, user_id: int):
    service = get_user_service()
    return service.get_user(user_id)
```

## Docker Compose 配置

```yaml
# docker/docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myproject
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
  
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
  
  backend:
    build:
      context: ..
      dockerfile: docker/Dockerfile
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - ../backend:/app
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/myproject
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis
  
  celery:
    build:
      context: ..
      dockerfile: docker/Dockerfile
    command: celery -A config worker -l info
    volumes:
      - ../backend:/app
    depends_on:
      - redis
      - db

volumes:
  postgres_data:
```

## 环境变量规范

```bash
# .env.example
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Redis
REDIS_URL=redis://localhost:6379/0

# Django
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Celery
CELERY_BROKER_URL=redis://localhost:6379/0
CELERY_RESULT_BACKEND=redis://localhost:6379/1

# API
API_VERSION=1.0.0
API_TITLE=My Project API
```

## 开发流程

### 1. 项目初始化

```bash
# 复制环境变量
cp .env.example .env

# 启动服务
docker-compose -f docker/docker-compose.yml up -d

# 运行迁移
docker-compose exec backend python manage.py migrate

# 创建超级用户
docker-compose exec backend python manage.py createsuperuser
```

### 2. 开发新模块

```bash
# 创建 app
cd backend
python manage.py startapp apps/products

# 按标准结构组织文件
apps/products/
├── __init__.py
├── models.py        # Django models
├── schemas.py       # Pydantic schemas
├── repositories.py  # 数据访问
├── services.py      # 业务逻辑
└── api.py          # API endpoints
```

### 3. 测试

```bash
# 单元测试
pytest tests/unit/

# 集成测试
pytest tests/integration/

# 覆盖率
pytest --cov=backend --cov-report=html
```

### 4. API 文档

访问自动生成的文档：
- Swagger UI: `http://localhost:8000/api/docs`
- ReDoc: `http://localhost:8000/api/redoc`

## 常见问题

### Q: 为什么不用 Django REST Framework？

A: Django Ninja 有以下优势：
- 基于 Pydantic，类型安全
- 性能更好（接近 FastAPI）
- 自动生成 OpenAPI 文档
- 更现代的 API 设计

### Q: 可以不用 Docker 吗？

A: 可以，但建议用 Docker 保证环境一致性。本地开发可以：
```bash
uv venv
source .venv/bin/activate
uv pip install -e .
python manage.py runserver
```

### Q: 如何处理认证？

A: 在 `apps/common/auth.py` 中定义：
```python
from ninja.security import HttpBearer

class AuthBearer(HttpBearer):
    def authenticate(self, request, token):
        # 验证 JWT token
        return validate_token(token)

# 使用
@router.get("/me", auth=AuthBearer())
def get_current_user(request):
    return request.auth
```

---

更多信息见 `SKILL.md`
