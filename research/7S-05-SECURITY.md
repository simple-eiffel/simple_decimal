# 7S-05: SECURITY


**Date**: 2026-01-23

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Security Considerations

### Input Validation

**String Parsing**
- Handles currency symbols ($)
- Handles commas (thousand separators)
- Handles spaces
- Negative values (-$99.99)

**Potential Issues:**
- Very long strings could cause memory issues
- Invalid characters produce undefined results

**Recommendation:** Validate input format before parsing

### Division by Zero

**Handled:** Precondition prevents
```eiffel
divide (other: like Current): SIMPLE_DECIMAL
    require
        other_not_zero: not other.is_zero
```

### Overflow/Underflow

**Status:** Gobo MA_DECIMAL handles:
- Arbitrary precision (no practical overflow)
- Exponent limits defined by context
- NaN and Infinity detection available

### Rounding Attacks

**Risk:** Manipulating rounding to accumulate pennies

**Mitigation:**
- Multiple rounding modes available
- Application chooses appropriate mode
- Banker's rounding default minimizes bias

## Financial Security Checklist

- [ ] Validate input strings before parsing
- [ ] Handle division by zero appropriately
- [ ] Use consistent rounding mode throughout
- [ ] Verify split() sums equal original
- [ ] Audit percentage calculations
- [ ] Log financial operations for audit trail
