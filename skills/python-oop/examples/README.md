# User Management Module - Python OOP 参考实现

这是 `python-oop-standards` skill 的完整参考实现。展示如何用严格的 OOP 方式组织 Python 代码。

## 模块结构

```
user_management/
├── __init__.py         # 模块导出
├── models.py           # 领域模型（dataclass）
├── repository.py       # 数据访问层（ABC + 实现）
├── validators.py       # 输入验证器
└── services.py         # 业务逻辑服务
```

## 核心设计模式

### 1. Dataclass Models（类型安全）

```python
@dataclass
class User:
    id: int
    username: str
    email: str
    role: UserRole
    status: UserStatus
    created_at: datetime
    updated_at: datetime
```

### 2. Repository Pattern（数据访问抽象）

```python
class UserRepository(ABC):
    @abstractmethod
    def find_by_id(self, user_id: int) -> User | None:
        pass
    
    @abstractmethod
    def save(self, user: User) -> User:
        pass
```

### 3. Service Layer（业务逻辑封装）

```python
class UserService:
    def __init__(
        self,
        repository: UserRepository,
        validator: UserValidator,
        password_hasher: PasswordHasher,
    ):
        self._repository = repository
        self._validator = validator
        self._password_hasher = password_hasher
```

### 4. Dependency Injection（依赖注入）

```python
# 通过构造函数注入，无全局依赖
repository = InMemoryUserRepository()
validator = UserValidator()
password_hasher = SimplePasswordHasher()

service = UserService(
    repository=repository,
    validator=validator,
    password_hasher=password_hasher,
)
```

## 完整代码

完整实现请参考同目录下的 `user_management/` 模块。

## 使用示例

```python
from user_management import (
    CreateUserRequest,
    UserService,
    UserRole,
)

# 创建用户
request = CreateUserRequest(
    username="john_doe",
    email="john@example.com",
    password="SecurePass123",
    role=UserRole.USER,
)

try:
    user = service.create_user(request)
    print(f"Created: {user.username}")
except UserServiceError as e:
    for error in e.errors:
        print(f"Error - {error.field}: {error.message}")
```

## 符合的 OOP 原则

✅ 无模块级 def 函数（除 main）  
✅ Dataclass 替代 dict  
✅ 依赖注入，无全局变量  
✅ ABC 抽象接口  
✅ Repository + Service 模式  
✅ 单一职责原则  
✅ 完整类型注解  
✅ 组合优于继承  

这是按照 `python-oop-standards` skill 编写的标准 Python 代码。
