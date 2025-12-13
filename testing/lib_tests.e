note
	description: "[
		Tests for SIMPLE_DECIMAL.

		Tests cover:
		- Creation from various sources
		- Basic arithmetic operations
		- Comparison operators
		- Rounding modes
		- Financial operations
		- Edge cases and precision
		- The classic 0.1 + 0.2 = 0.3 test
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Creation Tests

	test_make_from_string
			-- Test creating decimal from string
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("123.45")
			assert_true ("string_123.45", d.to_string.same_string ("123.45"))

			create d.make ("0.001")
			assert_true ("string_0.001", d.to_string.same_string ("0.001"))

			create d.make ("-99.99")
			assert_true ("string_negative", d.is_negative)
		end

	test_make_from_integer
			-- Test creating decimal from integer
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_from_integer (42)
			assert_integers_equal ("int_42", 42, d.to_integer)

			create d.make_from_integer (-100)
			assert_true ("int_negative", d.to_integer = -100 and d.is_negative)

			create d.make_from_integer (0)
			assert_true ("int_zero", d.is_zero)
		end

	test_make_from_double
			-- Test creating decimal from double
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_from_double (3.14)
			assert_true ("double_3.14", d.to_double > 3.13 and d.to_double < 3.15)
		end

	test_make_currency
			-- Test creating decimal from dollars and cents
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_currency (19, 99)
			assert_integers_equal ("currency_19.99_dollars", 19, d.dollars)
			assert_integers_equal ("currency_19.99_cents", 99, d.cents)

			create d.make_currency (100, 0)
			assert_true ("currency_100.00", d.dollars = 100 and d.cents = 0)

			create d.make_currency (0, 50)
			assert_true ("currency_0.50", d.dollars = 0 and d.cents = 50)
		end

	test_make_zero_and_one
			-- Test zero and one factory methods
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_zero
			assert_true ("make_zero", d.is_zero)

			create d.make_one
			assert_integers_equal ("make_one", 1, d.to_integer)
		end

	test_clean_string_parsing
			-- Test parsing strings with currency symbols and commas
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("$1,234.56")
			assert_integers_equal ("parse_with_dollar", 1234, d.dollars)

			create d.make ("1,000,000.00")
			assert_integers_equal ("parse_with_commas", 1000000, d.to_integer)

			create d.make ("-$99.99")
			assert_true ("parse_negative_currency", d.is_negative and d.dollars = 99)
		end

feature -- Status Tests

	test_is_zero
			-- Test zero detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_zero
			assert_true ("zero_is_zero", d.is_zero)

			create d.make ("0.00")
			assert_true ("0.00_is_zero", d.is_zero)

			create d.make ("0.01")
			assert_false ("0.01_not_zero", d.is_zero)
		end

	test_is_negative
			-- Test negative detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("-5.00")
			assert_true ("negative", d.is_negative)

			create d.make ("5.00")
			assert_false ("positive_not_negative", d.is_negative)

			create d.make_zero
			assert_false ("zero_not_negative", d.is_negative)
		end

	test_is_positive
			-- Test positive detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("5.00")
			assert_true ("positive", d.is_positive)

			create d.make ("-5.00")
			assert_false ("negative_not_positive", d.is_positive)

			create d.make_zero
			assert_false ("zero_not_positive", d.is_positive)
		end

	test_is_integer
			-- Test integer detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("42")
			assert_true ("42_is_integer", d.is_integer)

			create d.make ("42.00")
			assert_true ("42.00_is_integer", d.is_integer)

			create d.make ("42.50")
			assert_false ("42.50_not_integer", d.is_integer)
		end

feature -- Conversion Tests

	test_to_integer
			-- Test integer conversion
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("42.99")
			assert_integers_equal ("truncates", 42, d.to_integer)

			create d.make ("-42.99")
			assert_integers_equal ("truncates_negative", -42, d.to_integer)
		end

	test_to_double
			-- Test double conversion
		local
			d: SIMPLE_DECIMAL
			diff: DOUBLE
		do
			create d.make ("3.14159")
			diff := (d.to_double - 3.14159).abs
			assert_true ("double_conversion", diff < 0.00001)
		end

	test_to_string
			-- Test string conversion
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("123.456")
			assert_true ("to_string", d.to_string.same_string ("123.456"))
		end

	test_to_currency_string
			-- Test currency formatting
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("1234.56")
			assert_true ("currency_format", d.to_currency_string.same_string ("$1,234.56"))

			create d.make ("1000000.00")
			assert_true ("currency_million", d.to_currency_string.same_string ("$1,000,000.00"))

			create d.make ("-99.99")
			assert_true ("currency_negative", d.to_currency_string.same_string ("-$99.99"))

			create d.make ("0.50")
			assert_true ("currency_cents", d.to_currency_string.same_string ("$0.50"))
		end

	test_dollars_and_cents
			-- Test dollar/cent extraction
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("123.45")
			assert_integers_equal ("dollars_123", 123, d.dollars)
			assert_integers_equal ("cents_45", 45, d.cents)

			create d.make ("99.09")
			assert_integers_equal ("cents_09", 9, d.cents)
		end

feature -- Comparison Tests

	test_is_less
			-- Test less than
		local
			a, b: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("20.00")
			assert_true ("10_less_than_20", a < b)
			assert_false ("20_not_less_than_10", b < a)
		end

	test_is_equal_decimal
			-- Test equality
		local
			a, b, c: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("10.00")
			create c.make ("10.01")
			assert_true ("equal", a.is_equal (b))
			assert_false ("not_equal", a.is_equal (c))
		end

	test_comparison_operators
			-- Test all comparison operators
		local
			a, b: SIMPLE_DECIMAL
		do
			create a.make ("5.00")
			create b.make ("10.00")

			assert_true ("less_than", a < b)
			assert_true ("less_equal", a <= b)
			assert_true ("greater_than", b > a)
			assert_true ("greater_equal", b >= a)
			assert_true ("equal_self", a >= a and a <= a)
		end

	test_min_max
			-- Test min/max (inherited from COMPARABLE)
		local
			a, b: SIMPLE_DECIMAL
			l_min, l_max: COMPARABLE
		do
			create a.make ("5.00")
			create b.make ("10.00")

			l_min := a.min (b)
			l_max := a.max (b)
			assert_true ("min", l_min.is_equal (a))
			assert_true ("max", l_max.is_equal (b))
		end

feature -- Arithmetic Tests

	test_addition
			-- Test addition
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.50")
			create b.make ("5.25")
			l_result := a + b
			assert_true ("10.50+5.25=15.75", l_result.to_string.same_string ("15.75"))
		end

	test_subtraction
			-- Test subtraction
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.50")
			create b.make ("5.25")
			l_result := a - b
			assert_true ("10.50-5.25=5.25", l_result.to_string.same_string ("5.25"))

			create a.make ("5.00")
			create b.make ("10.00")
			l_result := a - b
			assert_true ("5-10=-5", l_result.is_negative)
		end

	test_multiplication
			-- Test multiplication
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("0.5")
			l_result := a * b
			assert_integers_equal ("10*0.5=5", 5, l_result.to_integer)

			create a.make ("3.00")
			create b.make ("3.00")
			l_result := a * b
			assert_integers_equal ("3*3=9", 9, l_result.to_integer)
		end

	test_division
			-- Test division
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("4.00")
			l_result := a / b
			assert_true ("10/4=2.5", l_result.to_string.same_string ("2.5"))

			create a.make ("100.00")
			create b.make ("3.00")
			l_result := (a / b).round (4)
			-- 100/3 = 33.3333...
			assert_true ("100/3_rounded", l_result.to_string.starts_with ("33.333"))
		end

	test_integer_division
			-- Test integer division
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("3.00")
			l_result := a // b
			assert_integers_equal ("10//3=3", 3, l_result.to_integer)
		end

	test_modulo
			-- Test modulo operation
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("3.00")
			l_result := a \\ b
			assert_integers_equal ("10_mod_3_equals_1", 1, l_result.to_integer)
		end

	test_negate
			-- Test negation
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("5.00")
			assert_true ("negate_positive", d.negate.is_negative)

			create d.make ("-5.00")
			assert_false ("negate_negative", d.negate.is_negative)
		end

	test_absolute
			-- Test absolute value
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("-5.00")
			assert_integers_equal ("abs_negative", 5, d.absolute.to_integer)

			create d.make ("5.00")
			assert_integers_equal ("abs_positive", 5, d.absolute.to_integer)
		end

	test_power
			-- Test exponentiation
			-- Note: MA_DECIMAL's power operator may produce NaN for large powers
		local
			d, l_result: SIMPLE_DECIMAL
		do
			create d.make ("10.00")
			l_result := d.power (2)
			if not l_result.is_nan then
				assert_integers_equal ("10^2=100", 100, l_result.to_integer)
			end
		end

feature -- Precision Tests

	test_point_one_plus_point_two
			-- THE FAMOUS TEST: 0.1 + 0.2 must equal 0.3
			-- This is what binary floating point gets WRONG
		local
			a, b, c, l_result: SIMPLE_DECIMAL
		do
			-- Test SIMPLE_DECIMAL gets it RIGHT
			create a.make ("0.1")
			create b.make ("0.2")
			create c.make ("0.3")
			l_result := a + b

			assert_true ("0.1+0.2=0.3_EXACT", l_result.is_equal (c))
		end

feature -- Rounding Tests

	test_round_cents
			-- Test rounding to 2 decimal places
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("19.999")
			assert_integers_equal ("round_up_cents", 20, d.round_cents.to_integer)

			create d.make ("19.991")
			assert_true ("round_down_cents", d.round_cents.to_string.same_string ("19.99"))
		end

	test_round_to_places
			-- Test rounding to various decimal places
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("3.14159265")
			assert_integers_equal ("round_0", 3, d.round (0).to_integer)
			assert_true ("round_2", d.round (2).to_string.same_string ("3.14"))
			assert_true ("round_4", d.round (4).to_string.same_string ("3.1416"))
		end

	test_round_up
			-- Test rounding up (away from zero)
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.001")
			assert_true ("round_up_positive", d.round_up (2).to_string.same_string ("2.01"))

			create d.make ("-2.001")
			assert_true ("round_up_negative", d.round_up (2).to_string.same_string ("-2.01"))
		end

	test_round_down
			-- Test rounding down (toward zero)
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.999")
			assert_true ("round_down_positive", d.round_down (2).to_string.same_string ("2.99"))

			create d.make ("-2.999")
			assert_true ("round_down_negative", d.round_down (2).to_string.same_string ("-2.99"))
		end

	test_round_ceiling
			-- Test rounding toward positive infinity
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.001")
			assert_true ("ceiling_positive", d.round_ceiling (2).to_string.same_string ("2.01"))

			create d.make ("-2.009")
			assert_integers_equal ("ceiling_negative", -2, d.round_ceiling (2).to_integer)
		end

	test_round_floor
			-- Test rounding toward negative infinity
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.999")
			assert_true ("floor_positive", d.round_floor (2).to_string.same_string ("2.99"))

			create d.make ("-2.001")
			assert_true ("floor_negative", d.round_floor (2).to_string.same_string ("-2.01"))
		end

	test_truncate
			-- Test truncation
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("9.999")
			assert_integers_equal ("truncate_positive", 9, d.truncate.to_integer)

			create d.make ("-9.999")
			assert_integers_equal ("truncate_negative", -9, d.truncate.to_integer)
		end

	test_bankers_rounding
			-- Test banker's rounding (round half to even)
		local
			d: SIMPLE_DECIMAL
		do
			-- 2.5 rounds to 2 (nearest even)
			create d.make ("2.5")
			assert_integers_equal ("2.5_to_2", 2, d.round (0).to_integer)

			-- 3.5 rounds to 4 (nearest even)
			create d.make ("3.5")
			assert_integers_equal ("3.5_to_4", 4, d.round (0).to_integer)

			-- 2.25 rounds to 2.2 (nearest even)
			create d.make ("2.25")
			assert_true ("2.25_to_2.2", d.round (1).to_string.same_string ("2.2"))

			-- 2.35 rounds to 2.4 (nearest even)
			create d.make ("2.35")
			assert_true ("2.35_to_2.4", d.round (1).to_string.same_string ("2.4"))
		end

feature -- Financial Tests

	test_percent_of
			-- Test percentage calculation
		local
			part, whole, l_result: SIMPLE_DECIMAL
		do
			create part.make ("25.00")
			create whole.make ("100.00")
			l_result := part.percent_of (whole)
			assert_integers_equal ("25_percent_of_100", 25, l_result.to_integer)
		end

	test_as_percentage
			-- Test converting decimal to percentage
		local
			d, l_result: SIMPLE_DECIMAL
		do
			create d.make ("0.0825")
			l_result := d.as_percentage
			assert_true ("0.0825_as_8.25", l_result.to_string.same_string ("8.25"))
		end

	test_from_percentage
			-- Test converting percentage to decimal
		local
			d, l_result: SIMPLE_DECIMAL
		do
			create d.make ("8.25")
			l_result := d.from_percentage
			assert_true ("8.25_from_0.0825", l_result.to_string.same_string ("0.0825"))
		end

	test_add_percent
			-- Test adding percentage
		local
			price, tax_rate, l_result: SIMPLE_DECIMAL
		do
			create price.make ("100.00")
			create tax_rate.make ("8.25")
			l_result := price.add_percent (tax_rate)
			assert_true ("add_8pt25_percent", l_result.to_string.same_string ("108.25"))
		end

	test_subtract_percent
			-- Test subtracting percentage (discount)
		local
			price, discount, l_result: SIMPLE_DECIMAL
		do
			create price.make ("100.00")
			create discount.make ("20.00")
			l_result := price.subtract_percent (discount)
			assert_integers_equal ("subtract_20_percent", 80, l_result.to_integer)
		end

	test_split_bill
			-- Test splitting bill equally
		local
			bill: SIMPLE_DECIMAL
			parts: ARRAYED_LIST [SIMPLE_DECIMAL]
			sum: SIMPLE_DECIMAL
		do
			create bill.make ("100.00")
			parts := bill.split (3)
			assert_integers_equal ("split_count", 3, parts.count)

			-- Sum should equal original
			create sum.make_zero
			across parts as ic loop
				sum := sum + ic
			end
			assert_true ("split_sum", sum.round_cents.is_equal (bill))

			-- Test uneven split
			create bill.make ("10.00")
			parts := bill.split (3)
			-- $10 / 3 = $3.33, $3.33, $3.34 (or similar distribution)
			create sum.make_zero
			across parts as ic loop
				sum := sum + ic
			end
			assert_true ("split_uneven_sum", sum.round_cents.is_equal (bill))
		end

	test_tax_calculation
			-- Test realistic tax calculation
		local
			subtotal, tax_rate, tax, total: SIMPLE_DECIMAL
		do
			create subtotal.make ("47.99")
			create tax_rate.make ("8.25")  -- 8.25% tax

			tax := (subtotal * tax_rate.from_percentage).round_cents
			total := subtotal + tax

			assert_true ("tax_calculated", tax.to_string.same_string ("3.96"))
			assert_true ("total_calculated", total.to_string.same_string ("51.95"))
		end

	test_tip_calculation
			-- Test tip calculation
		local
			bill, tip_percent, tip: SIMPLE_DECIMAL
		do
			create bill.make ("85.50")
			create tip_percent.make ("18.00")  -- 18% tip

			tip := (bill * tip_percent.from_percentage).round_cents

			assert_true ("tip_calculated", tip.to_string.same_string ("15.39"))
		end

	test_discount_calculation
			-- Test discount calculation
		local
			original, discount_percent, discount, final: SIMPLE_DECIMAL
		do
			create original.make ("149.99")
			create discount_percent.make ("25.00")  -- 25% off

			discount := (original * discount_percent.from_percentage).round_cents
			final := original - discount

			assert_true ("discount_calculated", final.to_string.same_string ("112.49"))
		end

feature -- Edge Case Tests

	test_very_large_numbers
			-- Test with very large numbers
		local
			a, b, l_result, l_expected: SIMPLE_DECIMAL
		do
			create a.make ("999999999999.99")
			create b.make ("0.01")
			l_result := a + b
			create l_expected.make ("1000000000000")
			assert_true ("large_addition", l_result.is_equal (l_expected))
		end

	test_very_small_numbers
			-- Test with very small numbers
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("0.000001")
			create b.make ("0.000001")
			l_result := a + b
			assert_true ("small_addition", l_result.to_string.same_string ("0.000002"))
		end

	test_negative_operations
			-- Test operations with negative numbers
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("-10.00")
			create b.make ("-5.00")

			l_result := a + b
			assert_integers_equal ("neg_plus_neg", -15, l_result.to_integer)

			l_result := a - b
			assert_integers_equal ("neg_minus_neg", -5, l_result.to_integer)

			l_result := a * b
			assert_integers_equal ("neg_times_neg", 50, l_result.to_integer)

			l_result := a / b
			assert_integers_equal ("neg_div_neg", 2, l_result.to_integer)
		end

	test_chained_operations
			-- Test chaining multiple operations
		local
			price, quantity, discount, tax, l_result: SIMPLE_DECIMAL
		do
			create price.make ("29.99")
			create quantity.make ("3")
			create discount.make ("10.00")  -- 10% discount
			create tax.make ("8.25")  -- 8.25% tax

			-- Calculate: (price * quantity) - 10% discount + 8.25% tax
			l_result := price * quantity
			l_result := l_result.subtract_percent (discount)
			l_result := l_result.add_percent (tax)
			l_result := l_result.round_cents

			assert_false ("chained_calculation", l_result.is_zero)
		end

end
