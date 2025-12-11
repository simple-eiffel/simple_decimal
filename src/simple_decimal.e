note
	description: "[
		SIMPLE_DECIMAL - Clean wrapper for precise decimal arithmetic.

		Part of the simple_* library ecosystem. Wraps Gobo's MA_DECIMAL to provide
		a simple, intuitive API for financial calculations and precise decimal math.

		Key Features:
		- Arbitrary precision decimal arithmetic (no floating-point errors)
		- Financial-friendly: perfect for currency, percentages, tax calculations
		- Immutable operations: a + b returns new decimal, originals unchanged
		- Chainable API: amount.add (tax).round_cents
		- Smart string parsing: handles "$1,234.56", "1234.56", "-$99.99"
		- Comparison operators: <, <=, >, >=, =, /=
		- Rounding modes: banker's rounding, floor, ceiling, truncate

		Quick Start:
			price: SIMPLE_DECIMAL
			tax: SIMPLE_DECIMAL
			total: SIMPLE_DECIMAL

			create price.make ("19.99")
			create tax.make ("0.0825")  -- 8.25% tax rate
			total := price.add (price.multiply (tax)).round_cents
			print (total.to_currency_string)  -- "$21.64"

		Why SIMPLE_DECIMAL over REAL/DOUBLE?
			-- DOUBLE fails:
			print ((0.1 + 0.2).out)  -- "0.30000000000000004" WRONG!

			-- SIMPLE_DECIMAL correct:
			create a.make ("0.1")
			create b.make ("0.2")
			print (a.add (b).out)  -- "0.3" CORRECT!

		Common Use Cases:
		- Currency/money calculations
		- Tax and percentage computations
		- Financial statements and reporting
		- Scientific calculations requiring precision
		- Any math where 0.1 + 0.2 MUST equal 0.3
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_DECIMAL

inherit
	ANY
		redefine
			default_create,
			out,
			is_equal
		end

	COMPARABLE
		undefine
			default_create,
			out,
			is_equal
		end

create
	default_create,
	make,
	make_from_integer,
	make_from_double,
	make_from_decimal,
	make_currency,
	make_zero,
	make_one

feature {NONE} -- Initialization

	default_create
			-- Create zero decimal
		do
			create decimal.make_zero
			create context.make_double_extended
		ensure then
			is_zero: is_zero
		end

	make (a_value: READABLE_STRING_GENERAL)
			-- Create from string representation.
			-- Accepts: "123.45", "-99.99", "1,234.56", "$1,234.56", "-$99.99"
		require
			value_not_empty: a_value /= Void and then not a_value.is_empty
		local
			l_clean: STRING
		do
			create context.make_double_extended
			l_clean := clean_string (a_value)
			create decimal.make_from_string_ctx (l_clean, context)
		ensure
			decimal_created: decimal /= Void
		end

	make_from_integer (a_value: INTEGER)
			-- Create from integer value
		do
			create context.make_double_extended
			create decimal.make_from_integer (a_value)
		ensure
			correct_value: to_integer = a_value
		end

	make_from_double (a_value: DOUBLE)
			-- Create from double value.
			-- Note: Prefer make() with string for exact precision.
			-- Double 0.1 is already imprecise before conversion.
		do
			create context.make_double_extended
			create decimal.make_from_string_ctx (a_value.out, context)
		end

	make_from_decimal (a_decimal: MA_DECIMAL)
			-- Create from existing MA_DECIMAL
		require
			decimal_not_void: a_decimal /= Void
		do
			create context.make_double_extended
			create decimal.make_copy (a_decimal)
		ensure
			decimal_created: decimal /= Void
		end

	make_currency (a_dollars: INTEGER; a_cents: INTEGER)
			-- Create from dollars and cents.
			-- Example: make_currency (19, 99) creates 19.99
		require
			cents_valid: a_cents >= 0 and a_cents <= 99
		local
			l_str: STRING
		do
			create context.make_double_extended
			create l_str.make (20)
			if a_dollars < 0 then
				l_str.append ("-")
				l_str.append_integer (a_dollars.abs)
			else
				l_str.append_integer (a_dollars)
			end
			l_str.append (".")
			if a_cents < 10 then
				l_str.append ("0")
			end
			l_str.append_integer (a_cents)
			create decimal.make_from_string_ctx (l_str, context)
		end

	make_zero
			-- Create zero
		do
			create context.make_double_extended
			create decimal.make_zero
		ensure
			is_zero: is_zero
		end

	make_one
			-- Create one
		do
			create context.make_double_extended
			create decimal.make_one
		ensure
			is_one: to_integer = 1
		end

feature -- Access

	decimal: MA_DECIMAL
			-- Underlying Gobo decimal (for advanced users)

	context: MA_DECIMAL_CONTEXT
			-- Decimal context for operations

feature -- Status

	is_zero: BOOLEAN
			-- Is this decimal zero?
		do
			Result := decimal.is_zero
		end

	is_negative: BOOLEAN
			-- Is this decimal negative?
		do
			Result := decimal.is_negative
		end

	is_positive: BOOLEAN
			-- Is this decimal positive (not zero, not negative)?
		do
			Result := not is_zero and not is_negative
		end

	is_integer: BOOLEAN
			-- Does this decimal have no fractional part?
		local
			l_rounded: MA_DECIMAL
		do
			l_rounded := decimal.round_to_integer (context)
			Result := decimal.is_equal (l_rounded)
		end

	is_nan: BOOLEAN
			-- Is this Not a Number?
		do
			Result := decimal.is_nan
		end

	is_infinity: BOOLEAN
			-- Is this infinity?
		do
			Result := decimal.is_infinity
		end

feature -- Conversion

	to_integer: INTEGER
			-- Convert to integer (truncates fractional part)
		require
			not_nan: not is_nan
			not_infinity: not is_infinity
		local
			l_truncated: MA_DECIMAL
		do
			l_truncated := decimal.round_to_integer (context)
			Result := l_truncated.to_integer
		end

	to_double: DOUBLE
			-- Convert to double (may lose precision)
		require
			not_nan: not is_nan
			not_infinity: not is_infinity
		do
			Result := decimal.to_double
		end

	out: STRING
			-- Standard string representation
		do
			Result := decimal.to_scientific_string
		end

	to_string: STRING
			-- Plain string representation (no scientific notation)
		do
			Result := decimal.to_engineering_string
		end

	to_currency_string: STRING
			-- Format as currency: "$1,234.56" or "-$1,234.56"
		local
			l_str: STRING
			l_abs: SIMPLE_DECIMAL
			l_parts: LIST [STRING]
			l_int_part: STRING
			l_dec_part: STRING
			i: INTEGER
			l_formatted: STRING
		do
			create Result.make (20)

			if is_negative then
				Result.append ("-")
				create l_abs.make_from_decimal (decimal.abs)
			else
				create l_abs.make_from_decimal (decimal)
			end

			Result.append ("$")
			l_str := l_abs.round_cents.to_string

			-- Split into integer and decimal parts
			l_parts := l_str.split ('.')
			if l_parts.count >= 1 then
				l_int_part := l_parts [1]
			else
				l_int_part := "0"
			end
			if l_parts.count >= 2 then
				l_dec_part := l_parts [2]
			else
				l_dec_part := "00"
			end

			-- Pad decimal part to 2 digits
			if l_dec_part.count < 2 then
				l_dec_part.append ("0")
			end

			-- Add thousand separators
			create l_formatted.make (l_int_part.count + 5)
			from
				i := l_int_part.count
			until
				i < 1
			loop
				if l_formatted.count > 0 and (l_int_part.count - i + 1) \\ 3 = 1 then
					l_formatted.prepend (",")
				end
				l_formatted.prepend_character (l_int_part [i])
				i := i - 1
			end

			Result.append (l_formatted)
			Result.append (".")
			Result.append (l_dec_part)
		ensure
			starts_with_dollar_or_minus: Result.count > 0 and then (Result [1] = '$' or Result [1] = '-')
		end

	dollars: INTEGER
			-- Integer dollar amount (absolute value)
		local
			l_truncated: MA_DECIMAL
		do
			l_truncated := decimal.abs.round_to_integer (context)
			Result := l_truncated.to_integer
		end

	cents: INTEGER
			-- Cents portion (0-99)
		local
			l_frac: MA_DECIMAL
			l_cents_dec: MA_DECIMAL
			l_hundred: MA_DECIMAL
		do
			l_frac := decimal.abs.remainder (one.decimal, context)
			create l_hundred.make_from_integer (100)
			l_cents_dec := l_frac.multiply (l_hundred, context)
			Result := l_cents_dec.round_to_integer (context).to_integer
		ensure
			valid_range: Result >= 0 and Result <= 99
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current decimal less than other?
		do
			Result := decimal < other.decimal
		end

	is_equal (other: like Current): BOOLEAN
			-- Are decimals equal?
		do
			Result := decimal.is_equal (other.decimal)
		end

feature -- Arithmetic (Immutable - returns new SIMPLE_DECIMAL)

	add alias "+" (other: like Current): SIMPLE_DECIMAL
			-- Sum of current and other
		require
			other_not_void: other /= Void
		do
			create Result.make_from_decimal (decimal.add (other.decimal, context))
		ensure
			result_not_void: Result /= Void
		end

	subtract alias "-" (other: like Current): SIMPLE_DECIMAL
			-- Difference of current and other
		require
			other_not_void: other /= Void
		do
			create Result.make_from_decimal (decimal.subtract (other.decimal, context))
		ensure
			result_not_void: Result /= Void
		end

	multiply alias "*" (other: like Current): SIMPLE_DECIMAL
			-- Product of current and other
		require
			other_not_void: other /= Void
		do
			create Result.make_from_decimal (decimal.multiply (other.decimal, context))
		ensure
			result_not_void: Result /= Void
		end

	divide alias "/" (other: like Current): SIMPLE_DECIMAL
			-- Quotient of current divided by other
		require
			other_not_void: other /= Void
			other_not_zero: not other.is_zero
		do
			create Result.make_from_decimal (decimal.divide (other.decimal, context))
		ensure
			result_not_void: Result /= Void
		end

	integer_divide alias "//" (other: like Current): SIMPLE_DECIMAL
			-- Integer division (floor)
		require
			other_not_void: other /= Void
			other_not_zero: not other.is_zero
		do
			create Result.make_from_decimal (decimal.divide_integer (other.decimal, context))
		ensure
			result_not_void: Result /= Void
			result_is_integer: Result.is_integer
		end

	modulo alias "\\" (other: like Current): SIMPLE_DECIMAL
			-- Remainder after integer division
		require
			other_not_void: other /= Void
			other_not_zero: not other.is_zero
		do
			create Result.make_from_decimal (decimal.remainder (other.decimal, context))
		ensure
			result_not_void: Result /= Void
		end

	negate: SIMPLE_DECIMAL
			-- Negated value
		do
			create Result.make_from_decimal (decimal.minus (context))
		ensure
			result_not_void: Result /= Void
			sign_flipped: Result.is_negative /= is_negative or is_zero
		end

	absolute: SIMPLE_DECIMAL
			-- Absolute value
		do
			create Result.make_from_decimal (decimal.abs)
		ensure
			result_not_void: Result /= Void
			result_not_negative: not Result.is_negative
		end

	power (n: INTEGER): SIMPLE_DECIMAL
			-- Current raised to integer power n
		local
			l_n: MA_DECIMAL
		do
			create l_n.make_from_integer (n)
			create Result.make_from_decimal (decimal ^ l_n)
		ensure
			result_not_void: Result /= Void
		end

feature -- Rounding

	round_cents: SIMPLE_DECIMAL
			-- Round to 2 decimal places (for currency)
		do
			Result := round (2)
		ensure
			result_not_void: Result /= Void
		end

	round (a_places: INTEGER): SIMPLE_DECIMAL
			-- Round to specified decimal places using banker's rounding
		require
			places_non_negative: a_places >= 0
		do
			create Result.make_from_decimal (decimal.rescale (-a_places, context))
		ensure
			result_not_void: Result /= Void
		end

	round_up (a_places: INTEGER): SIMPLE_DECIMAL
			-- Round up (away from zero) to specified decimal places
		require
			places_non_negative: a_places >= 0
		local
			l_ctx: MA_DECIMAL_CONTEXT
		do
			create l_ctx.make_double_extended
			l_ctx.set_rounding_mode (l_ctx.round_up)
			create Result.make_from_decimal (decimal.rescale (-a_places, l_ctx))
		ensure
			result_not_void: Result /= Void
		end

	round_down (a_places: INTEGER): SIMPLE_DECIMAL
			-- Round down (toward zero) to specified decimal places (truncate)
		require
			places_non_negative: a_places >= 0
		local
			l_ctx: MA_DECIMAL_CONTEXT
		do
			create l_ctx.make_double_extended
			l_ctx.set_rounding_mode (l_ctx.round_down)
			create Result.make_from_decimal (decimal.rescale (-a_places, l_ctx))
		ensure
			result_not_void: Result /= Void
		end

	round_ceiling (a_places: INTEGER): SIMPLE_DECIMAL
			-- Round toward positive infinity
		require
			places_non_negative: a_places >= 0
		local
			l_ctx: MA_DECIMAL_CONTEXT
		do
			create l_ctx.make_double_extended
			l_ctx.set_rounding_mode (l_ctx.round_ceiling)
			create Result.make_from_decimal (decimal.rescale (-a_places, l_ctx))
		ensure
			result_not_void: Result /= Void
		end

	round_floor (a_places: INTEGER): SIMPLE_DECIMAL
			-- Round toward negative infinity
		require
			places_non_negative: a_places >= 0
		local
			l_ctx: MA_DECIMAL_CONTEXT
		do
			create l_ctx.make_double_extended
			l_ctx.set_rounding_mode (l_ctx.round_floor)
			create Result.make_from_decimal (decimal.rescale (-a_places, l_ctx))
		ensure
			result_not_void: Result /= Void
		end

	truncate: SIMPLE_DECIMAL
			-- Remove fractional part (round toward zero)
		do
			Result := round_down (0)
		ensure
			result_not_void: Result /= Void
			result_is_integer: Result.is_integer
		end

feature -- Financial Operations

	percent_of (a_base: like Current): SIMPLE_DECIMAL
			-- Current as percentage of base.
			-- Example: tip.percent_of (bill) returns percentage
		require
			base_not_void: a_base /= Void
			base_not_zero: not a_base.is_zero
		local
			l_hundred: SIMPLE_DECIMAL
		do
			create l_hundred.make_from_integer (100)
			Result := (Current / a_base) * l_hundred
		ensure
			result_not_void: Result /= Void
		end

	as_percentage: SIMPLE_DECIMAL
			-- Multiply by 100 (convert 0.08 to 8.0)
		local
			l_hundred: SIMPLE_DECIMAL
		do
			create l_hundred.make_from_integer (100)
			Result := Current * l_hundred
		ensure
			result_not_void: Result /= Void
		end

	from_percentage: SIMPLE_DECIMAL
			-- Divide by 100 (convert 8.0 to 0.08)
		local
			l_hundred: SIMPLE_DECIMAL
		do
			create l_hundred.make_from_integer (100)
			Result := Current / l_hundred
		ensure
			result_not_void: Result /= Void
		end

	add_percent (a_percent: like Current): SIMPLE_DECIMAL
			-- Add percentage to current.
			-- Example: price.add_percent (tax_rate) where tax_rate is 8.25
		require
			percent_not_void: a_percent /= Void
		local
			l_factor: SIMPLE_DECIMAL
		do
			l_factor := a_percent.from_percentage
			Result := Current + (Current * l_factor)
		ensure
			result_not_void: Result /= Void
		end

	subtract_percent (a_percent: like Current): SIMPLE_DECIMAL
			-- Subtract percentage from current (discount).
			-- Example: price.subtract_percent (discount) where discount is 15.0
		require
			percent_not_void: a_percent /= Void
		local
			l_factor: SIMPLE_DECIMAL
		do
			l_factor := a_percent.from_percentage
			Result := Current - (Current * l_factor)
		ensure
			result_not_void: Result /= Void
		end

	split (n: INTEGER): ARRAYED_LIST [SIMPLE_DECIMAL]
			-- Split amount into n equal parts, handling remainder.
			-- Example: bill.split (3) distributes $100 as [$33.34, $33.33, $33.33]
			-- First parts get the extra cents to ensure sum equals original.
		require
			n_positive: n > 0
		local
			l_base: SIMPLE_DECIMAL
			l_total: SIMPLE_DECIMAL
			l_remainder: SIMPLE_DECIMAL
			l_one_cent: SIMPLE_DECIMAL
			l_n: SIMPLE_DECIMAL
			i: INTEGER
		do
			create Result.make (n)
			create l_n.make_from_integer (n)
			l_base := (Current / l_n).round_cents

			-- Calculate total from base amounts
			create l_total.make_zero
			from i := 1 until i > n loop
				l_total := l_total + l_base
				i := i + 1
			end

			-- Remainder to distribute
			l_remainder := Current - l_total
			create l_one_cent.make ("0.01")

			-- Distribute: first items get extra penny if needed
			from i := 1 until i > n loop
				if l_remainder >= l_one_cent then
					Result.extend (l_base + l_one_cent)
					l_remainder := l_remainder - l_one_cent
				elseif l_remainder <= l_one_cent.negate then
					Result.extend (l_base - l_one_cent)
					l_remainder := l_remainder + l_one_cent
				else
					Result.extend (l_base)
				end
				i := i + 1
			end
		ensure
			correct_count: Result.count = n
			sum_equals_original: sum_list (Result).round_cents.is_equal (round_cents)
		end

feature -- Factory helpers

	zero: SIMPLE_DECIMAL
			-- Zero value
		do
			create Result.make_zero
		ensure
			result_is_zero: Result.is_zero
		end

	one: SIMPLE_DECIMAL
			-- One value
		do
			create Result.make_one
		ensure
			result_is_one: Result.to_integer = 1
		end

feature {NONE} -- Implementation

	clean_string (a_value: READABLE_STRING_GENERAL): STRING
			-- Remove currency symbols and commas from string
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_value.count)
			from i := 1 until i > a_value.count loop
				c := a_value [i]
				if c /= '$' and c /= ',' and c /= ' ' then
					Result.append_character (c.to_character_8)
				end
				i := i + 1
			end
		end

	sum_list (a_list: ARRAYED_LIST [SIMPLE_DECIMAL]): SIMPLE_DECIMAL
			-- Sum all decimals in list
		local
			l_item: SIMPLE_DECIMAL
		do
			create Result.make_zero
			across a_list as ic loop
				l_item := ic
				Result := Result + l_item
			end
		end

invariant
	decimal_exists: decimal /= Void
	context_exists: context /= Void

end
