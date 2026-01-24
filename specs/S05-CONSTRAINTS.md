# S05: CONSTRAINTS

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Technical Constraints

### Value Constraints

| Constraint | Enforcement | Reason |
|------------|-------------|--------|
| value /= Void | Invariant | Core data required |
| Division by zero | Precondition | Undefined result |
| Non-negative exponent | Precondition | Integer power only |
| Cents 0-99 | Precondition | Valid cents range |
| Split parts >= 1 | Precondition | At least one part |
| Round places >= 0 | Precondition | Non-negative decimals |

### Precision Constraints

Using Gobo MA_DECIMAL_CONTEXT defaults:
- **Default precision:** Sufficient for financial (typically 34 digits)
- **Rounding mode:** Half-even (banker's rounding)

## Behavioral Constraints

### Immutability

All arithmetic operations return NEW objects:
```eiffel
a := create {SIMPLE_DECIMAL}.make ("10")
b := create {SIMPLE_DECIMAL}.make ("5")
c := a.add (b)
-- a still equals 10
-- b still equals 5
-- c equals 15
```

### Split Guarantee

```eiffel
split (n: INTEGER): ARRAYED_LIST [SIMPLE_DECIMAL]
    ensure
        correct_count: Result.count = n
        sum_equals_original: sum(Result) = Current
```

Remainder is distributed one cent at a time to early elements.

### Comparison Semantics

Follows COMPARABLE contract:
- Total ordering
- Transitivity
- Antisymmetry

## Performance Constraints

- Operations: O(precision)
- Memory per instance: O(precision)
- No memoization of results
