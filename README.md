<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/.github/main/profile/assets/logo.png" alt="simple_ library logo" width="400">
</p>

# simple_decimal

**[Documentation](https://simple-eiffel.github.io/simple_decimal/)** | **[GitHub](https://github.com/simple-eiffel/simple_decimal)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

Clean wrapper for precise decimal arithmetic in Eiffel. Perfect for financial calculations where floating-point errors are unacceptable.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

**Developed using AI-assisted methodology:** Built interactively with Claude Opus 4.5 following rigorous Design by Contract principles.

## The Problem

Binary floating-point (REAL, DOUBLE) cannot represent many decimal fractions exactly:

```eiffel
-- DOUBLE fails silently!
io.put_double (0.1 + 0.2)  -- Outputs: 0.30000000000000004  WRONG!
```

This causes real-world problems:
- Financial calculations that don't balance
- Prices that display incorrectly
- Tax calculations that are off by a penny
- Cumulative errors in accounting systems

## The Solution

SIMPLE_DECIMAL uses arbitrary-precision decimal arithmetic:

```eiffel
local
    a, b, total: SIMPLE_DECIMAL
do
    create a.make ("0.1")
    create b.make ("0.2")
    total := a + b
    print (total.out)  -- Outputs: 0.3  CORRECT!
end
```

## Quick Start

```eiffel
class
    INVOICE_CALCULATOR

feature -- Calculation

    calculate_total (subtotal_str: STRING; tax_rate_str: STRING): STRING
            -- Calculate total with tax, returning formatted currency
        local
            subtotal, tax_rate, tax, total: SIMPLE_DECIMAL
        do
            create subtotal.make (subtotal_str)
            create tax_rate.make (tax_rate_str)

            -- Calculate tax: subtotal * (rate / 100)
            tax := (subtotal * tax_rate.from_percentage).round_cents
            total := subtotal + tax

            Result := total.to_currency_string
        end

end
```

**Usage:**
```eiffel
calculator.calculate_total ("47.99", "8.25")  -- Returns: "$51.95"
```

## Features

### Creation Methods

```eiffel
-- From string (most precise)
create price.make ("19.99")
create rate.make ("0.0825")

-- From integer
create count.make_from_integer (42)

-- From dollars and cents
create amount.make_currency (19, 99)  -- $19.99

-- Special values
create zero.make_zero
create one.make_one
```

### Arithmetic Operations

All operations are immutable (return new SIMPLE_DECIMAL):

```eiffel
result := a + b      -- Addition
result := a - b      -- Subtraction
result := a * b      -- Multiplication
result := a / b      -- Division
result := a // b     -- Integer division
result := a \ b     -- Modulo (remainder)
result := a.negate   -- Negation
result := a.absolute -- Absolute value
```

### Comparison

```eiffel
if price < budget then ...
if a <= b then ...
if total > limit then ...
if a >= b then ...
if a.is_equal (b) then ...
```

### Rounding

```eiffel
-- Round to cents (2 decimal places)
total := price.round_cents

-- Round to N decimal places
pi := value.round (4)  -- 3.1416

-- Rounding modes
up := value.round_up (2)       -- Away from zero
down := value.round_down (2)   -- Toward zero
ceil := value.round_ceiling (2) -- Toward +infinity
floor := value.round_floor (2)  -- Toward -infinity
trunc := value.truncate         -- Remove fractional part
```

### Financial Operations

```eiffel
-- Percentage calculations
tax := subtotal.add_percent (tax_rate)     -- Add 8.25% tax
sale := price.subtract_percent (discount)  -- Subtract 20% discount

-- Convert between decimal and percentage
rate := decimal.as_percentage    -- 0.0825 -> 8.25
decimal := rate.from_percentage  -- 8.25 -> 0.0825

-- Split bill
parts := bill.split (3)  -- Split $100 into 3 equal parts
-- Returns: [$33.34, $33.33, $33.33] (sum equals original)
```

### Output Formatting

```eiffel
print (amount.out)               -- "1234.56"
print (amount.to_string)         -- "1234.56"
print (amount.to_currency_string) -- "$1,234.56"
print (amount.dollars.out)       -- "1234"
print (amount.cents.out)         -- "56"
```

## Installation

### Environment Setup

Add to your environment (one-time setup for all simple_* libraries):

```bash
export SIMPLE_EIFFEL=D:\prod
```

### ECF Configuration

Add to your project's `.ecf` file:

```xml
<library name="simple_decimal" location="$SIMPLE_EIFFEL/simple_decimal/simple_decimal.ecf"/>
```

### Dependencies

- EiffelStudio 25.02+
- Gobo Math Library (included with EiffelStudio)

## Building from Source

```bash
cd /path/to/simple_decimal
ec.exe -batch -config simple_decimal.ecf -target simple_decimal_tests -c_compile

# Run tests
./EIFGENs/simple_decimal_tests/W_code/simple_decimal.exe
```

## License

MIT License - See [LICENSE](LICENSE) file.

## Resources

- [Simple Eiffel Organization](https://github.com/simple-eiffel)
- [General Decimal Arithmetic](http://speleotrove.com/decimal/)
- [IEEE 754-2008 Standard](https://en.wikipedia.org/wiki/IEEE_754)
