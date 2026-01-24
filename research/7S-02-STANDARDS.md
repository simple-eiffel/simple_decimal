# 7S-02: STANDARDS


**Date**: 2026-01-23

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Applicable Standards

### Primary Standard

**IEEE 754-2008 - Floating-Point Arithmetic**
- Defines decimal floating-point formats
- Specifies rounding modes
- Used by underlying Gobo MA_DECIMAL

### Related Standards

**General Decimal Arithmetic Specification**
- URL: http://speleotrove.com/decimal/
- Author: Mike Cowlishaw (IBM)
- Basis for MA_DECIMAL implementation

## Rounding Modes (IEEE 754)

| Mode | Description | simple_decimal |
|------|-------------|----------------|
| Round half even | Banker's rounding | round() default |
| Round up | Away from zero | round_up() |
| Round down | Toward zero | round_down() |
| Round ceiling | Toward +infinity | round_ceiling() |
| Round floor | Toward -infinity | round_floor() |

## Currency Formatting

No formal standard, but follows common conventions:
- US: $1,234.56
- Negative: -$1,234.56 (prefix minus)
- Thousand separators: comma
- Decimal separator: period

## Implementation Approach

simple_decimal wraps Gobo's MA_DECIMAL which implements:
- General Decimal Arithmetic Specification
- Arbitrary precision
- IEEE 754-2008 rounding modes
- Context-based precision control
