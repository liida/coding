---
name: python-oop
description: Python 面向对象编码规范。强制类优先架构、Repository/Service 模式、依赖注入、dataclass/Pydantic 模型。适用于所有 Python 项目。由 workflow 自动调用或手动触发。
metadata:
  short-description: Python OOP 编码规范
  layer: coding-standards
  language: python
  dependencies: []
---

# Python OOP - 编码规范

**定位**：编码规范层，定义如何编写 Python 代码，不涉及项目结构和工作流。

## 职责范围

本 skill **专注于**：
- ✅ 如何组织 Python 代码（类优先架构）
- ✅ 如何定义数据模型（dataclass/Pydantic）
- ✅ 如何管理依赖（依赖注入）
- ✅ 设计模式（Repository、Service、ABC）

本 skill **不涉及**：
- ❌ 项目目录结构（由框架 skill 定义，如 django-ninja）
- ❌ 工作流程（由 workflow 定义）
- ❌ 框架特定规范（由框架 skill 定义）

## 触发方式

1. **自动触发**：`workflow` 检测到 Python 项目时自动加载
2. **手动触发**：`/python-oop` 或在提示词中提及

## 适用范围

所有 Python 代码，包括：
- Web 框架（Django、FastAPI、Flask）
- CLI 工具
- 数据处理脚本
- 库开发

## Mission

Enforce object-oriented design patterns in Python. Eliminate scattered `def` functions at module level. Organize all logic into classes with clear responsibilities.

## Core Principles

1. **Class-First Architecture** — All business logic belongs in classes, not loose functions
2. **Single Responsibility** — Each class has one clear purpose
3. **Type Safety** — Use dataclasses/Pydantic models, never raw dicts
4. **Explicit Over Implicit** — Clear class hierarchies over functional composition

## Mandatory Patterns

### 1. No Module-Level Functions (CRITICAL)

**NEVER write standalone `def` at module level except:**
- `main()` entry point
- Private helpers prefixed with `_` that are 5 lines or fewer
- Type guards like `def is_valid_email(s: str) -> bool`

**Instead, organize into classes:**

```python
# ❌ WRONG — scattered functions
def fetch_user(user_id: int) -> dict:
    ...

def update_user(user_id: int, data: dict) -> None:
    ...

def delete_user(user_id: int) -> None:
    ...

# ✅ CORRECT — class-based organization
class UserRepository:
    def __init__(self, db: Database):
        self._db = db
    
    def fetch(self, user_id: int) -> User:
        ...
    
    def update(self, user_id: int, data: UserUpdateData) -> None:
        ...
    
    def delete(self, user_id: int) -> None:
        ...
```

### 2. Dataclasses/Pydantic Over Dicts (CRITICAL)

**NEVER pass or return raw `dict` for structured data.**

```python
# ❌ WRONG
def create_user(data: dict) -> dict:
    return {"id": 1, "name": data["name"]}

# ✅ CORRECT — typed models
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str

@dataclass
class CreateUserRequest:
    name: str
    email: str

class UserService:
    def create(self, request: CreateUserRequest) -> User:
        return User(id=1, name=request.name, email=request.email)
```

### 3. Service Layer Pattern

Group related operations into service classes:

```python
class UserService:
    """Business logic for user operations."""
    
    def __init__(self, repo: UserRepository, email_service: EmailService):
        self._repo = repo
        self._email = email_service
    
    def register(self, request: RegisterUserRequest) -> User:
        user = self._repo.create(request)
        self._email.send_welcome(user.email)
        return user
```

### 4. Repository Pattern for Data Access

Wrap all database/API calls in repository classes:

```python
class UserRepository:
    """Data access layer for users."""
    
    def __init__(self, db: Database):
        self._db = db
    
    def find_by_id(self, user_id: int) -> User | None:
        ...
    
    def find_by_email(self, email: str) -> User | None:
        ...
    
    def save(self, user: User) -> User:
        ...
```

### 5. Use ABC for Interfaces

Define interfaces with `abc.ABC`:

```python
from abc import ABC, abstractmethod

class EmailService(ABC):
    @abstractmethod
    def send(self, to: str, subject: str, body: str) -> None:
        ...

class SMTPEmailService(EmailService):
    def send(self, to: str, subject: str, body: str) -> None:
        # SMTP implementation
        ...

class MockEmailService(EmailService):
    def send(self, to: str, subject: str, body: str) -> None:
        print(f"Mock email to {to}")
```

### 6. Static Methods Only for Pure Functions

Use `@staticmethod` sparingly, only for pure utility functions within a class:

```python
class UserValidator:
    @staticmethod
    def is_valid_email(email: str) -> bool:
        return "@" in email and "." in email
    
    def validate(self, user: User) -> list[str]:
        errors = []
        if not self.is_valid_email(user.email):
            errors.append("Invalid email")
        return errors
```

### 7. Dependency Injection

Always pass dependencies through `__init__`, never use globals or singletons:

```python
# ❌ WRONG — global dependency
db = Database()

class UserService:
    def get_user(self, user_id: int):
        return db.query(...)

# ✅ CORRECT — injected dependency
class UserService:
    def __init__(self, db: Database):
        self._db = db
    
    def get_user(self, user_id: int):
        return self._db.query(...)
```

### 8. Prefer Composition Over Inheritance

Max 2 levels of inheritance. Beyond that, use composition:

```python
# ❌ WRONG — deep inheritance
class Animal: ...
class Mammal(Animal): ...
class Primate(Mammal): ...
class Human(Primate): ...

# ✅ CORRECT — composition
@dataclass
class Species:
    name: str
    classification: str

@dataclass
class Animal:
    species: Species
    traits: list[Trait]
```

## Class Organization

Standard order for class members:

1. Class variables
2. `__init__` constructor
3. Public methods (alphabetically)
4. Private methods prefixed with `_` (alphabetically)
5. Properties (`@property`)
6. Static methods (`@staticmethod`)
7. Class methods (`@classmethod`)

```python
class Example:
    # 1. Class variables
    DEFAULT_TIMEOUT = 30
    
    # 2. Constructor
    def __init__(self, name: str):
        self._name = name
    
    # 3. Public methods
    def process(self) -> None:
        self._validate()
    
    # 4. Private methods
    def _validate(self) -> None:
        ...
    
    # 5. Properties
    @property
    def name(self) -> str:
        return self._name
    
    # 6. Static methods
    @staticmethod
    def parse(data: str) -> dict:
        ...
    
    # 7. Class methods
    @classmethod
    def from_config(cls, config: dict) -> "Example":
        ...
```

## Type Hints (MANDATORY)

All public methods must have complete type hints:

```python
# ✅ CORRECT
class Calculator:
    def add(self, a: int, b: int) -> int:
        return a + b
    
    def divide(self, a: float, b: float) -> float | None:
        return a / b if b != 0 else None
```

Use modern Python 3.10+ syntax:
- `list[str]` not `List[str]`
- `dict[str, int]` not `Dict[str, int]`
- `int | None` not `Optional[int]`

## When to Break the Rules

Only acceptable scenarios for module-level functions:

1. **Entry point:** `def main() -> None:`
2. **Type guards:** Small validators like `def is_email(s: str) -> bool:`
3. **Tiny private helpers:** `def _clamp(x: int, min: int, max: int) -> int:`

If a helper is used by multiple classes, create a utility class:

```python
class StringUtils:
    @staticmethod
    def truncate(text: str, max_len: int) -> str:
        return text[:max_len] if len(text) > max_len else text
```

## Common Violations

### Violation: Utility Module with Functions

```python
# ❌ utils.py with loose functions
def format_date(dt): ...
def parse_json(s): ...
def retry(func, times): ...
```

**Fix:** Group into utility classes by concern

```python
# ✅ utils.py with utility classes
class DateFormatter:
    @staticmethod
    def format(dt: datetime) -> str: ...

class JsonParser:
    @staticmethod
    def parse(s: str) -> dict: ...

class RetryHelper:
    def __init__(self, max_attempts: int = 3):
        self.max_attempts = max_attempts
    
    def execute(self, func: Callable[[], T]) -> T: ...
```

### Violation: Procedural Script Style

```python
# ❌ main.py with procedural code
def load_config():
    ...

def connect_db():
    ...

def process_data():
    ...

if __name__ == "__main__":
    config = load_config()
    db = connect_db()
    process_data()
```

**Fix:** Application class

```python
# ✅ Object-oriented application
class Application:
    def __init__(self):
        self._config = self._load_config()
        self._db = self._connect_db()
    
    def run(self) -> None:
        self._process_data()
    
    def _load_config(self) -> Config: ...
    def _connect_db(self) -> Database: ...
    def _process_data(self) -> None: ...

def main() -> None:
    app = Application()
    app.run()

if __name__ == "__main__":
    main()
```

## Code Review Checklist

When reviewing Python code, verify:

- [ ] No module-level `def` except `main()` and tiny `_helpers`
- [ ] All data structures use dataclasses/Pydantic, not dicts
- [ ] All public methods have complete type hints
- [ ] Classes follow Single Responsibility Principle
- [ ] Dependencies injected via `__init__`, no globals
- [ ] Repository pattern for data access
- [ ] Service pattern for business logic
- [ ] ABC used for interfaces
- [ ] Max 2 levels of inheritance
- [ ] Class members in standard order

## Enforcement

Run mypy in strict mode to catch type violations:

```bash
mypy --strict --warn-unreachable --warn-redundant-casts .
```

Use ruff to enforce code quality:

```bash
ruff check --select=C,N,D .
```

## Philosophy

"Explicit classes over implicit functions. Structure over scripts. Types over dicts."

Code is read more than written. Classes provide:
- Clear namespace boundaries
- Explicit dependencies
- Easy mocking for tests
- IDE autocomplete support
- Type safety

Embrace Python's OOP capabilities. Write maintainable, testable, enterprise-grade code.
