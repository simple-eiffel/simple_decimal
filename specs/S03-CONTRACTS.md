# S03: CONTRACTS

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Class Invariants

### SIMPLE_DECIMAL

```eiffel
invariant
    value_exists: value /= Void
```

## Feature Contracts

### Creation Contracts

#### make_currency
```eiffel
require
    cents_valid: cents >= 0 and cents < 100
```

### Arithmetic Contracts

#### divide
```eiffel
require
    other_not_zero: not other.is_zero
ensure
    result_exists: Result /= Void
```

#### integer_divide (//)
```eiffel
require
    other_not_zero: not other.is_zero
ensure
    result_exists: Result /= Void
```

#### remainder (\\)
```eiffel
require
    other_not_zero: not other.is_zero
ensure
    result_exists: Result /= Void
```

#### power
```eiffel
require
    exponent_valid: a_exponent >= 0
ensure
    result_exists: Result /= Void
```

### Rounding Contracts

#### round
```eiffel
require
    valid_places: a_places >= 0
ensure
    result_exists: Result /= Void
```

### Financial Contracts

#### split
```eiffel
require
    valid_parts: a_parts >= 1
ensure
    correct_count: Result.count = a_parts
    sum_equals_original: -- sum of Result = Current
```

### Conversion Contracts

All conversion features:
```eiffel
ensure
    result_exists: Result /= Void
```

## Comparison Contracts

```eiffel
is_less (other: like Current): BOOLEAN
    require
        other_exists: other /= Void
```
