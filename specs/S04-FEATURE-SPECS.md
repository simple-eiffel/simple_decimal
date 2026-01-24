# S04: FEATURE SPECIFICATIONS

**Library:** simple_decimal
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Initialization Features

### default_create
**Signature:** `default_create`
**Purpose:** Create decimal with value zero

### make
**Signature:** `make (a_value: STRING)`
**Purpose:** Create from string representation
**Parsing:** Handles "$", commas, spaces, negative signs
**Examples:** "123.45", "$1,234.56", "-$99.99"

### make_from_integer
**Signature:** `make_from_integer (a_value: INTEGER)`
**Purpose:** Create from 32-bit integer

### make_currency
**Signature:** `make_currency (a_dollars, a_cents: INTEGER)`
**Purpose:** Create from dollars and cents
**Example:** make_currency (19, 99) => 19.99

## Arithmetic Features

All return new SIMPLE_DECIMAL (immutable operations)

### add (+)
**Signature:** `add (other: like Current): SIMPLE_DECIMAL`
**Purpose:** Addition

### subtract (-)
**Signature:** `subtract (other: like Current): SIMPLE_DECIMAL`
**Purpose:** Subtraction

### multiply (*)
**Signature:** `multiply (other: like Current): SIMPLE_DECIMAL`
**Purpose:** Multiplication

### divide (/)
**Signature:** `divide (other: like Current): SIMPLE_DECIMAL`
**Purpose:** Division (result may have many decimal places)

### integer_divide (//)
**Signature:** `integer_divide (other: like Current): SIMPLE_DECIMAL`
**Purpose:** Integer division (floor of quotient)

## Rounding Features

### round
**Signature:** `round (a_places: INTEGER): SIMPLE_DECIMAL`
**Purpose:** Round to specified decimal places
**Mode:** Banker's rounding (half to even)

### round_cents
**Signature:** `round_cents: SIMPLE_DECIMAL`
**Purpose:** Shortcut for round(2)

## Financial Features

### percent_of
**Signature:** `percent_of (a_percent: SIMPLE_DECIMAL): SIMPLE_DECIMAL`
**Purpose:** Calculate percentage of this value
**Example:** 100.percent_of(15) => 15.00

### add_percent
**Signature:** `add_percent (a_percent: SIMPLE_DECIMAL): SIMPLE_DECIMAL`
**Purpose:** Add percentage to value
**Example:** 100.add_percent(8.25) => 108.25

### split
**Signature:** `split (a_parts: INTEGER): ARRAYED_LIST [SIMPLE_DECIMAL]`
**Purpose:** Divide into equal parts, distribute remainder
**Guarantee:** Sum of parts equals original
