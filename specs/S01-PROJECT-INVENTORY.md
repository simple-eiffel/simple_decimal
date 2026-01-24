# S01: PROJECT INVENTORY

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Project Structure

```
simple_decimal/
├── src/
│   └── simple_decimal.e       # Main decimal class
├── testing/
│   ├── test_app.e             # Test entry point
│   └── lib_tests.e            # Unit tests
├── research/                   # 7S research documents
├── specs/                      # Specification documents
├── simple_decimal.ecf         # Library ECF
└── README.md                   # Documentation
```

## File Inventory

| File | Type | Lines | Purpose |
|------|------|-------|---------|
| simple_decimal.e | Source | 735 | Decimal arithmetic class |
| test_app.e | Test | ~30 | Test entry point |
| lib_tests.e | Test | ~120 | Unit tests |

## Dependencies

### Gobo Libraries (Required)
- MA_DECIMAL - Core decimal implementation
- MA_DECIMAL_CONTEXT - Precision/rounding context
- MA_SHARED_DECIMAL_CONTEXT - Shared context access

### Eiffel Base Libraries
- ARRAYED_LIST
- STRING

## Build Configuration

**ECF Targets:**
- `simple_decimal` - Library target
- `simple_decimal_tests` - Test target

**Required ECF Dependencies:**
```xml
<library name="gobo_decimal"
        location="${GOBO}/library/math/library.ecf"/>
```

## Version Information

- **Current Phase:** Production
- **API Stability:** Stable
- **Eiffel Version:** 25.02+
- **Gobo Version:** Compatible with EiffelStudio 25.02
