# 7S-03: SOLUTIONS


**Date**: 2026-01-23

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Existing Solutions Comparison

### Language Solutions

| Solution | Language | Approach | API Complexity |
|----------|----------|----------|----------------|
| decimal.Decimal | Python | Arbitrary precision | Medium |
| BigDecimal | Java | Arbitrary precision | High |
| decimal | Go | Fixed precision | Low |
| Decimal | C# | 128-bit fixed | Low |
| MA_DECIMAL | Eiffel (Gobo) | Arbitrary precision | High |
| **SIMPLE_DECIMAL** | **Eiffel** | **Wrapper over Gobo** | **Low** |

### Why Wrap MA_DECIMAL?

MA_DECIMAL is powerful but verbose:
```eiffel
-- MA_DECIMAL (Gobo)
create ctx.make_double_extended
create d1.make_from_string_ctx ("19.99", ctx)
create d2.make_from_string_ctx ("0.0825", ctx)
d3 := d1.multiply (d2, ctx)
d4 := d3.rescale (-2, ctx)
```

SIMPLE_DECIMAL simplifies:
```eiffel
-- SIMPLE_DECIMAL
create price.make ("19.99")
create tax_rate.make ("0.0825")
total := price.add (price.multiply (tax_rate)).round_cents
```

### Unique Features

1. **Operator aliases:** +, -, *, /, //, \\
2. **Currency-focused:** make_currency, to_currency_string, dollars, cents
3. **Financial operations:** percent_of, add_percent, subtract_percent, split
4. **Smart parsing:** Handles "$1,234.56" format
5. **Immutable operations:** All arithmetic returns new objects
