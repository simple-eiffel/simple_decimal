# 7S-01: SCOPE

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Problem Domain

Floating-point arithmetic in computers suffers from precision errors:
```
0.1 + 0.2 = 0.30000000000000004  -- WRONG!
```

This is unacceptable for:
- Financial calculations
- Currency handling
- Tax computations
- Scientific precision requirements

Decimal arithmetic provides exact representation of base-10 numbers.

## Target Users

1. **Financial Application Developers** - Money calculations
2. **E-commerce Developers** - Pricing, taxes, discounts
3. **Accounting Systems** - Statements, balances
4. **Scientific Applications** - Precise calculations

## Boundaries

### In Scope
- Arbitrary precision decimal arithmetic
- Financial-friendly API (dollars/cents, currency formatting)
- Immutable operations (functional style)
- Multiple rounding modes
- Percentage calculations
- Bill splitting
- String parsing (including currency format)
- Comparison operators

### Out of Scope
- Complex numbers
- Matrix operations
- Trigonometric functions
- Symbolic math
- Unit conversion

## Key Capabilities

1. **Precision:** Exact decimal representation
2. **Operations:** Add, subtract, multiply, divide, power
3. **Rounding:** Banker's, floor, ceiling, truncate
4. **Financial:** Currency formatting, percent calculations, bill splitting
5. **Parsing:** Handles "$1,234.56", "-$99.99", "1234.56"
