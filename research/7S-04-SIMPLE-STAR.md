# 7S-04: SIMPLE-STAR Ecosystem Integration


**Date**: 2026-01-23

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Ecosystem Dependencies

### Required Libraries
- **Gobo MA_DECIMAL** - Core decimal arithmetic implementation
- **Gobo MA_DECIMAL_CONTEXT** - Precision and rounding configuration

### No simple_* dependencies
Self-contained wrapper over Gobo.

## Integration Patterns

### Usage Example

```eiffel
-- E-commerce pricing
price: SIMPLE_DECIMAL
tax_rate: SIMPLE_DECIMAL
discount: SIMPLE_DECIMAL
total: SIMPLE_DECIMAL

create price.make ("99.99")
create tax_rate.make ("8.25")      -- 8.25%
create discount.make ("15.0")      -- 15% off

-- Calculate discounted price with tax
total := price.subtract_percent (discount)   -- Apply discount
              .add_percent (tax_rate)        -- Add tax
              .round_cents                   -- Round to cents

print (total.to_currency_string)  -- "$90.72"
```

### Bill Splitting

```eiffel
-- Split bill among friends
bill: SIMPLE_DECIMAL
shares: ARRAYED_LIST [SIMPLE_DECIMAL]

create bill.make ("127.53")
shares := bill.split (4)
-- First share might be $31.89, others $31.88
-- Sum always equals original
```

## API Consistency

Follows simple_* patterns:
- **Multiple creation procedures** - make, make_from_integer, make_currency, etc.
- **Operator aliases** - Eiffel operator overloading
- **Immutable operations** - Returns new objects
- **Design by Contract** - Full preconditions/postconditions

## Ecosystem Value

Essential for any financial operations in Eiffel applications.
