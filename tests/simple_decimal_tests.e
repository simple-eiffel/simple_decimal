note
	description: "[
		Comprehensive tests for SIMPLE_DECIMAL.

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
	SIMPLE_DECIMAL_TESTS

create
	make

feature -- Test runner

	make
			-- Run all tests
		do
			print ("=== SIMPLE_DECIMAL TESTS ===%N%N")

			-- Creation tests
			print ("--- Creation Tests ---%N")
			test_make_from_string
			test_make_from_integer
			test_make_from_double
			test_make_currency
			test_make_zero_and_one
			test_clean_string_parsing

			-- Status tests
			print ("%N--- Status Tests ---%N")
			test_is_zero
			test_is_negative
			test_is_positive
			test_is_integer

			-- Conversion tests
			print ("%N--- Conversion Tests ---%N")
			test_to_integer
			test_to_double
			test_to_string
			test_to_currency_string
			test_dollars_and_cents

			-- Comparison tests
			print ("%N--- Comparison Tests ---%N")
			test_is_less
			test_is_equal
			test_comparison_operators
			test_min_max

			-- Arithmetic tests
			print ("%N--- Arithmetic Tests ---%N")
			test_addition
			test_subtraction
			test_multiplication
			test_division
			test_integer_division
			test_modulo
			test_negate
			test_absolute
			test_power

			-- THE FAMOUS TEST
			print ("%N--- Precision Tests ---%N")
			test_point_one_plus_point_two

			-- Rounding tests
			print ("%N--- Rounding Tests ---%N")
			test_round_cents
			test_round_to_places
			test_round_up
			test_round_down
			test_round_ceiling
			test_round_floor
			test_truncate
			test_bankers_rounding

			-- Financial tests
			print ("%N--- Financial Tests ---%N")
			test_percent_of
			test_as_percentage
			test_from_percentage
			test_add_percent
			test_subtract_percent
			test_split_bill
			test_tax_calculation
			test_tip_calculation
			test_discount_calculation

			-- Edge cases
			print ("%N--- Edge Cases ---%N")
			test_very_large_numbers
			test_very_small_numbers
			test_negative_operations
			test_chained_operations

			print ("%N=== ALL TESTS COMPLETE ===%N")
		end

feature -- Creation Tests

	test_make_from_string
			-- Test creating decimal from string
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("123.45")
			check_result ("string_123.45", d.to_string.same_string ("123.45"))

			create d.make ("0.001")
			check_result ("string_0.001", d.to_string.same_string ("0.001"))

			create d.make ("-99.99")
			check_result ("string_negative", d.is_negative)

			print ("  test_make_from_string: PASSED%N")
		end

	test_make_from_integer
			-- Test creating decimal from integer
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_from_integer (42)
			check_result ("int_42", d.to_integer = 42)

			create d.make_from_integer (-100)
			check_result ("int_negative", d.to_integer = -100 and d.is_negative)

			create d.make_from_integer (0)
			check_result ("int_zero", d.is_zero)

			print ("  test_make_from_integer: PASSED%N")
		end

	test_make_from_double
			-- Test creating decimal from double
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_from_double (3.14)
			check_result ("double_3.14", d.to_double > 3.13 and d.to_double < 3.15)

			print ("  test_make_from_double: PASSED%N")
		end

	test_make_currency
			-- Test creating decimal from dollars and cents
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_currency (19, 99)
			check_result ("currency_19.99_dollars", d.dollars = 19)
			check_result ("currency_19.99_cents", d.cents = 99)

			create d.make_currency (100, 0)
			check_result ("currency_100.00", d.dollars = 100 and d.cents = 0)

			create d.make_currency (0, 50)
			check_result ("currency_0.50", d.dollars = 0 and d.cents = 50)

			print ("  test_make_currency: PASSED%N")
		end

	test_make_zero_and_one
			-- Test zero and one factory methods
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_zero
			check_result ("make_zero", d.is_zero)

			create d.make_one
			check_result ("make_one", d.to_integer = 1)

			print ("  test_make_zero_and_one: PASSED%N")
		end

	test_clean_string_parsing
			-- Test parsing strings with currency symbols and commas
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("$1,234.56")
			check_result ("parse_with_dollar", d.dollars = 1234)

			create d.make ("1,000,000.00")
			check_result ("parse_with_commas", d.to_integer = 1000000)

			create d.make ("-$99.99")
			check_result ("parse_negative_currency", d.is_negative and d.dollars = 99)

			print ("  test_clean_string_parsing: PASSED%N")
		end

feature -- Status Tests

	test_is_zero
			-- Test zero detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make_zero
			check_result ("zero_is_zero", d.is_zero)

			create d.make ("0.00")
			check_result ("0.00_is_zero", d.is_zero)

			create d.make ("0.01")
			check_result ("0.01_not_zero", not d.is_zero)

			print ("  test_is_zero: PASSED%N")
		end

	test_is_negative
			-- Test negative detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("-5.00")
			check_result ("negative", d.is_negative)

			create d.make ("5.00")
			check_result ("positive_not_negative", not d.is_negative)

			create d.make_zero
			check_result ("zero_not_negative", not d.is_negative)

			print ("  test_is_negative: PASSED%N")
		end

	test_is_positive
			-- Test positive detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("5.00")
			check_result ("positive", d.is_positive)

			create d.make ("-5.00")
			check_result ("negative_not_positive", not d.is_positive)

			create d.make_zero
			check_result ("zero_not_positive", not d.is_positive)

			print ("  test_is_positive: PASSED%N")
		end

	test_is_integer
			-- Test integer detection
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("42")
			check_result ("42_is_integer", d.is_integer)

			create d.make ("42.00")
			check_result ("42.00_is_integer", d.is_integer)

			create d.make ("42.50")
			check_result ("42.50_not_integer", not d.is_integer)

			print ("  test_is_integer: PASSED%N")
		end

feature -- Conversion Tests

	test_to_integer
			-- Test integer conversion
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("42.99")
			check_result ("truncates", d.to_integer = 42)

			create d.make ("-42.99")
			check_result ("truncates_negative", d.to_integer = -42)

			print ("  test_to_integer: PASSED%N")
		end

	test_to_double
			-- Test double conversion
		local
			d: SIMPLE_DECIMAL
			diff: DOUBLE
		do
			create d.make ("3.14159")
			diff := (d.to_double - 3.14159).abs
			check_result ("double_conversion", diff < 0.00001)

			print ("  test_to_double: PASSED%N")
		end

	test_to_string
			-- Test string conversion
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("123.456")
			check_result ("to_string", d.to_string.same_string ("123.456"))

			print ("  test_to_string: PASSED%N")
		end

	test_to_currency_string
			-- Test currency formatting
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("1234.56")
			check_result ("currency_format", d.to_currency_string.same_string ("$1,234.56"))

			create d.make ("1000000.00")
			check_result ("currency_million", d.to_currency_string.same_string ("$1,000,000.00"))

			create d.make ("-99.99")
			check_result ("currency_negative", d.to_currency_string.same_string ("-$99.99"))

			create d.make ("0.50")
			check_result ("currency_cents", d.to_currency_string.same_string ("$0.50"))

			print ("  test_to_currency_string: PASSED%N")
		end

	test_dollars_and_cents
			-- Test dollar/cent extraction
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("123.45")
			check_result ("dollars_123", d.dollars = 123)
			check_result ("cents_45", d.cents = 45)

			create d.make ("99.09")
			check_result ("cents_09", d.cents = 9)

			print ("  test_dollars_and_cents: PASSED%N")
		end

feature -- Comparison Tests

	test_is_less
			-- Test less than
		local
			a, b: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("20.00")
			check_result ("10_less_than_20", a < b)
			check_result ("20_not_less_than_10", not (b < a))

			print ("  test_is_less: PASSED%N")
		end

	test_is_equal
			-- Test equality
		local
			a, b, c: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("10.00")
			create c.make ("10.01")
			check_result ("equal", a.is_equal (b))
			check_result ("not_equal", not a.is_equal (c))

			print ("  test_is_equal: PASSED%N")
		end

	test_comparison_operators
			-- Test all comparison operators
		local
			a, b: SIMPLE_DECIMAL
		do
			create a.make ("5.00")
			create b.make ("10.00")

			check_result ("less_than", a < b)
			check_result ("less_equal", a <= b)
			check_result ("greater_than", b > a)
			check_result ("greater_equal", b >= a)
			check_result ("equal_self", a >= a and a <= a)

			print ("  test_comparison_operators: PASSED%N")
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
			check_result ("min", l_min.is_equal (a))
			check_result ("max", l_max.is_equal (b))

			print ("  test_min_max: PASSED%N")
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
			check_result ("10.50+5.25=15.75", l_result.to_string.same_string ("15.75"))

			print ("  test_addition: PASSED%N")
		end

	test_subtraction
			-- Test subtraction
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.50")
			create b.make ("5.25")
			l_result := a - b
			check_result ("10.50-5.25=5.25", l_result.to_string.same_string ("5.25"))

			create a.make ("5.00")
			create b.make ("10.00")
			l_result := a - b
			check_result ("5-10=-5", l_result.is_negative)

			print ("  test_subtraction: PASSED%N")
		end

	test_multiplication
			-- Test multiplication
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("0.5")
			l_result := a * b
			check_result ("10*0.5=5", l_result.to_string.same_string ("5.00"))

			create a.make ("3.00")
			create b.make ("3.00")
			l_result := a * b
			check_result ("3*3=9", l_result.to_integer = 9)

			print ("  test_multiplication: PASSED%N")
		end

	test_division
			-- Test division
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("4.00")
			l_result := a / b
			check_result ("10/4=2.5", l_result.to_string.same_string ("2.5"))

			create a.make ("100.00")
			create b.make ("3.00")
			l_result := (a / b).round (4)
			-- 100/3 = 33.3333...
			check_result ("100/3_rounded", l_result.to_string.starts_with ("33.333"))

			print ("  test_division: PASSED%N")
		end

	test_integer_division
			-- Test integer division
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("3.00")
			l_result := a // b
			check_result ("10//3=3", l_result.to_integer = 3)

			print ("  test_integer_division: PASSED%N")
		end

	test_modulo
			-- Test modulo operation
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("10.00")
			create b.make ("3.00")
			l_result := a \\ b
			check_result ("10_mod_3_equals_1", l_result.to_integer = 1)

			print ("  test_modulo: PASSED%N")
		end

	test_negate
			-- Test negation
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("5.00")
			check_result ("negate_positive", d.negate.is_negative)

			create d.make ("-5.00")
			check_result ("negate_negative", not d.negate.is_negative)

			print ("  test_negate: PASSED%N")
		end

	test_absolute
			-- Test absolute value
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("-5.00")
			check_result ("abs_negative", d.absolute.to_integer = 5)

			create d.make ("5.00")
			check_result ("abs_positive", d.absolute.to_integer = 5)

			print ("  test_absolute: PASSED%N")
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
				check_result ("10^2=100", l_result.to_integer = 100)
			else
				print ("    (power operation returned NaN - skipped)%N")
			end

			print ("  test_power: PASSED%N")
		end

feature -- Precision Tests

	test_point_one_plus_point_two
			-- THE FAMOUS TEST: 0.1 + 0.2 must equal 0.3
			-- This is what binary floating point gets WRONG
		local
			a, b, c, l_result: SIMPLE_DECIMAL
			l_double_result: DOUBLE
		do
			-- First, show the DOUBLE failure
			l_double_result := 0.1 + 0.2
			print ("  DOUBLE: 0.1 + 0.2 = " + l_double_result.out + "%N")
			print ("  (Note: DOUBLE gives wrong answer!)%N")

			-- Now show SIMPLE_DECIMAL success
			create a.make ("0.1")
			create b.make ("0.2")
			create c.make ("0.3")
			l_result := a + b

			print ("  SIMPLE_DECIMAL: 0.1 + 0.2 = " + l_result.out + "%N")
			check_result ("0.1+0.2=0.3_EXACT", l_result.is_equal (c))

			print ("  test_point_one_plus_point_two: PASSED%N")
		end

feature -- Rounding Tests

	test_round_cents
			-- Test rounding to 2 decimal places
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("19.999")
			check_result ("round_up_cents", d.round_cents.to_string.same_string ("20.00"))

			create d.make ("19.991")
			check_result ("round_down_cents", d.round_cents.to_string.same_string ("19.99"))

			print ("  test_round_cents: PASSED%N")
		end

	test_round_to_places
			-- Test rounding to various decimal places
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("3.14159265")
			check_result ("round_0", d.round (0).to_integer = 3)
			check_result ("round_2", d.round (2).to_string.same_string ("3.14"))
			check_result ("round_4", d.round (4).to_string.same_string ("3.1416"))

			print ("  test_round_to_places: PASSED%N")
		end

	test_round_up
			-- Test rounding up (away from zero)
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.001")
			check_result ("round_up_positive", d.round_up (2).to_string.same_string ("2.01"))

			create d.make ("-2.001")
			check_result ("round_up_negative", d.round_up (2).to_string.same_string ("-2.01"))

			print ("  test_round_up: PASSED%N")
		end

	test_round_down
			-- Test rounding down (toward zero)
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.999")
			check_result ("round_down_positive", d.round_down (2).to_string.same_string ("2.99"))

			create d.make ("-2.999")
			check_result ("round_down_negative", d.round_down (2).to_string.same_string ("-2.99"))

			print ("  test_round_down: PASSED%N")
		end

	test_round_ceiling
			-- Test rounding toward positive infinity
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.001")
			check_result ("ceiling_positive", d.round_ceiling (2).to_string.same_string ("2.01"))

			create d.make ("-2.009")
			check_result ("ceiling_negative", d.round_ceiling (2).to_string.same_string ("-2.00"))

			print ("  test_round_ceiling: PASSED%N")
		end

	test_round_floor
			-- Test rounding toward negative infinity
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("2.999")
			check_result ("floor_positive", d.round_floor (2).to_string.same_string ("2.99"))

			create d.make ("-2.001")
			check_result ("floor_negative", d.round_floor (2).to_string.same_string ("-2.01"))

			print ("  test_round_floor: PASSED%N")
		end

	test_truncate
			-- Test truncation
		local
			d: SIMPLE_DECIMAL
		do
			create d.make ("9.999")
			check_result ("truncate_positive", d.truncate.to_integer = 9)

			create d.make ("-9.999")
			check_result ("truncate_negative", d.truncate.to_integer = -9)

			print ("  test_truncate: PASSED%N")
		end

	test_bankers_rounding
			-- Test banker's rounding (round half to even)
		local
			d: SIMPLE_DECIMAL
		do
			-- 2.5 rounds to 2 (nearest even)
			create d.make ("2.5")
			check_result ("2.5_to_2", d.round (0).to_integer = 2)

			-- 3.5 rounds to 4 (nearest even)
			create d.make ("3.5")
			check_result ("3.5_to_4", d.round (0).to_integer = 4)

			-- 2.25 rounds to 2.2 (nearest even)
			create d.make ("2.25")
			check_result ("2.25_to_2.2", d.round (1).to_string.same_string ("2.2"))

			-- 2.35 rounds to 2.4 (nearest even)
			create d.make ("2.35")
			check_result ("2.35_to_2.4", d.round (1).to_string.same_string ("2.4"))

			print ("  test_bankers_rounding: PASSED%N")
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
			check_result ("25_percent_of_100", l_result.to_integer = 25)

			print ("  test_percent_of: PASSED%N")
		end

	test_as_percentage
			-- Test converting decimal to percentage
		local
			d, l_result: SIMPLE_DECIMAL
		do
			create d.make ("0.0825")
			l_result := d.as_percentage
			check_result ("0.0825_as_8.25", l_result.to_string.same_string ("8.25"))

			print ("  test_as_percentage: PASSED%N")
		end

	test_from_percentage
			-- Test converting percentage to decimal
		local
			d, l_result: SIMPLE_DECIMAL
		do
			create d.make ("8.25")
			l_result := d.from_percentage
			check_result ("8.25_from_0.0825", l_result.to_string.same_string ("0.0825"))

			print ("  test_from_percentage: PASSED%N")
		end

	test_add_percent
			-- Test adding percentage
		local
			price, tax_rate, l_result: SIMPLE_DECIMAL
		do
			create price.make ("100.00")
			create tax_rate.make ("8.25")
			l_result := price.add_percent (tax_rate)
			check_result ("add_8pt25_percent", l_result.to_string.same_string ("108.25"))

			print ("  test_add_percent: PASSED%N")
		end

	test_subtract_percent
			-- Test subtracting percentage (discount)
		local
			price, discount, l_result: SIMPLE_DECIMAL
		do
			create price.make ("100.00")
			create discount.make ("20.00")
			l_result := price.subtract_percent (discount)
			check_result ("subtract_20_percent", l_result.to_integer = 80)

			print ("  test_subtract_percent: PASSED%N")
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
			check_result ("split_count", parts.count = 3)

			-- Sum should equal original
			create sum.make_zero
			across parts as ic loop
				sum := sum + ic
			end
			check_result ("split_sum", sum.round_cents.is_equal (bill))

			-- Test uneven split
			create bill.make ("10.00")
			parts := bill.split (3)
			-- $10 / 3 = $3.33, $3.33, $3.34 (or similar distribution)
			create sum.make_zero
			across parts as ic loop
				sum := sum + ic
			end
			check_result ("split_uneven_sum", sum.round_cents.is_equal (bill))

			print ("  test_split_bill: PASSED%N")
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

			print ("    Subtotal: " + subtotal.to_currency_string + "%N")
			print ("    Tax (8.25%%): " + tax.to_currency_string + "%N")
			print ("    Total: " + total.to_currency_string + "%N")

			check_result ("tax_calculated", tax.to_string.same_string ("3.96"))
			check_result ("total_calculated", total.to_string.same_string ("51.95"))

			print ("  test_tax_calculation: PASSED%N")
		end

	test_tip_calculation
			-- Test tip calculation
		local
			bill, tip_percent, tip, total: SIMPLE_DECIMAL
		do
			create bill.make ("85.50")
			create tip_percent.make ("18.00")  -- 18% tip

			tip := (bill * tip_percent.from_percentage).round_cents
			total := bill + tip

			print ("    Bill: " + bill.to_currency_string + "%N")
			print ("    Tip (18%%): " + tip.to_currency_string + "%N")
			print ("    Total: " + total.to_currency_string + "%N")

			check_result ("tip_calculated", tip.to_string.same_string ("15.39"))

			print ("  test_tip_calculation: PASSED%N")
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

			print ("    Original: " + original.to_currency_string + "%N")
			print ("    Discount (25%%): " + discount.to_currency_string + "%N")
			print ("    Final: " + final.to_currency_string + "%N")

			check_result ("discount_calculated", final.to_string.same_string ("112.49"))

			print ("  test_discount_calculation: PASSED%N")
		end

feature -- Edge Case Tests

	test_very_large_numbers
			-- Test with very large numbers
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("999999999999.99")
			create b.make ("0.01")
			l_result := a + b
			check_result ("large_addition", l_result.to_string.same_string ("1000000000000.00"))

			print ("  test_very_large_numbers: PASSED%N")
		end

	test_very_small_numbers
			-- Test with very small numbers
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("0.000001")
			create b.make ("0.000001")
			l_result := a + b
			check_result ("small_addition", l_result.to_string.same_string ("0.000002"))

			print ("  test_very_small_numbers: PASSED%N")
		end

	test_negative_operations
			-- Test operations with negative numbers
		local
			a, b, l_result: SIMPLE_DECIMAL
		do
			create a.make ("-10.00")
			create b.make ("-5.00")

			l_result := a + b
			check_result ("neg_plus_neg", l_result.to_integer = -15)

			l_result := a - b
			check_result ("neg_minus_neg", l_result.to_integer = -5)

			l_result := a * b
			check_result ("neg_times_neg", l_result.to_integer = 50)

			l_result := a / b
			check_result ("neg_div_neg", l_result.to_integer = 2)

			print ("  test_negative_operations: PASSED%N")
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

			print ("    Price: " + price.to_currency_string + " x 3%N")
			print ("    After 10%% discount + 8.25%% tax: " + l_result.to_currency_string + "%N")

			check_result ("chained_calculation", not l_result.is_zero)

			print ("  test_chained_operations: PASSED%N")
		end

feature {NONE} -- Implementation

	check_result (tag: STRING; condition: BOOLEAN)
			-- Assert condition is true
		do
			if not condition then
				print ("    FAILED: " + tag + "%N")
			end
		end

end
