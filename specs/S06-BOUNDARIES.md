# S06: BOUNDARIES

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## System Boundaries

### Class Structure

```
+------------------+
|  SIMPLE_DECIMAL  |
|------------------|
| wraps            |
|    +----------+  |
|    | MA_DECIMAL | |  (Gobo)
|    +----------+  |
+------------------+
```

### Inheritance

```
COMPARABLE [SIMPLE_DECIMAL]
         |
   SIMPLE_DECIMAL
```

### Gobo Dependencies

```
SIMPLE_DECIMAL
    |
    +-- MA_DECIMAL (value storage, arithmetic)
    |
    +-- MA_DECIMAL_CONTEXT (precision, rounding)
    |
    +-- MA_SHARED_DECIMAL_CONTEXT (shared context)
```

## Responsibilities

### SIMPLE_DECIMAL Responsibilities
- Simplified creation procedures
- String parsing (including currency format)
- Operator aliases
- Currency formatting output
- Financial operations (percentages, split)
- Delegation to MA_DECIMAL

### MA_DECIMAL Responsibilities (Gobo)
- Arbitrary precision storage
- Core arithmetic operations
- Rounding algorithms
- IEEE 754 compliance

## Integration Points

| Integration | Direction | Data |
|-------------|-----------|------|
| Application | Input | Strings, integers, reals |
| Application | Output | Strings, numeric types |
| MA_DECIMAL | Internal | Arithmetic operations |

## Not Responsible For

- Parsing complex number formats (scientific notation limited)
- Currency localization
- Exchange rate calculations
- Database storage format
- Serialization
