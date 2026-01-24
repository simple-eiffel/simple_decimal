# S02: CLASS CATALOG

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Class Overview

| Class | Purpose | LOC |
|-------|---------|-----|
| SIMPLE_DECIMAL | Arbitrary precision decimal arithmetic | 735 |

## SIMPLE_DECIMAL

### Description
Wrapper around Gobo MA_DECIMAL providing simple, financial-friendly decimal arithmetic.

### Inheritance
```
SIMPLE_DECIMAL
    inherit COMPARABLE [SIMPLE_DECIMAL]
        redefine out, default_create, is_equal
```

### Creation Procedures

| Name | Signature | Purpose |
|------|-----------|---------|
| default_create | | Create zero |
| make | (value: STRING) | From string |
| make_from_integer | (value: INTEGER) | From integer |
| make_from_integer_64 | (value: INTEGER_64) | From 64-bit int |
| make_from_real | (value: REAL_64) | From float |
| make_currency | (dollars, cents: INTEGER) | From dollars.cents |
| make_from_ma_decimal | (value: MA_DECIMAL) | From Gobo decimal |

### Feature Groups

**Access:** value (MA_DECIMAL)

**Status:** is_zero, is_negative, is_positive, is_nan, is_infinite, sign

**Conversion:** to_real_64, to_integer, to_integer_64, to_string_full, to_currency_string, out

**Comparison:** is_less, is_equal (supports <, >, =, <=, >=)

**Arithmetic:** add (+), subtract (-), multiply (*), divide (/), integer_divide (//), remainder (\\), abs, negate, power

**Rounding:** round, round_up, round_down, round_ceiling, round_floor, round_cents

**Financial:** percent_of, add_percent, subtract_percent, dollars, cents, split

### Operator Aliases

| Operator | Feature |
|----------|---------|
| + | add |
| - | subtract |
| * | multiply |
| / | divide |
| // | integer_divide |
| \\ | remainder |
