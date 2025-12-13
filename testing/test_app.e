note
	description: "[
		Test application for simple_decimal library.

		Runs all tests from LIB_TESTS and prints results to console.
		Can be run directly (CLI) or from EiffelStudio.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run all tests
		do
			print ("=== SIMPLE_DECIMAL TESTS ===%N%N")
			create tests

			run_creation_tests
			run_status_tests
			run_conversion_tests
			run_comparison_tests
			run_arithmetic_tests
			run_precision_tests
			run_rounding_tests
			run_financial_tests
			run_edge_case_tests

			print ("%N=== RESULTS: " + passed_count.out + " passed, " + failed_count.out + " failed ===%N")
		end

feature {NONE} -- Test groups

	run_creation_tests
			-- Run creation tests
		do
			print ("--- Creation Tests ---%N")
			run_test (agent tests.test_make_from_string, "test_make_from_string")
			run_test (agent tests.test_make_from_integer, "test_make_from_integer")
			run_test (agent tests.test_make_from_double, "test_make_from_double")
			run_test (agent tests.test_make_currency, "test_make_currency")
			run_test (agent tests.test_make_zero_and_one, "test_make_zero_and_one")
			run_test (agent tests.test_clean_string_parsing, "test_clean_string_parsing")
		end

	run_status_tests
			-- Run status tests
		do
			print ("%N--- Status Tests ---%N")
			run_test (agent tests.test_is_zero, "test_is_zero")
			run_test (agent tests.test_is_negative, "test_is_negative")
			run_test (agent tests.test_is_positive, "test_is_positive")
			run_test (agent tests.test_is_integer, "test_is_integer")
		end

	run_conversion_tests
			-- Run conversion tests
		do
			print ("%N--- Conversion Tests ---%N")
			run_test (agent tests.test_to_integer, "test_to_integer")
			run_test (agent tests.test_to_double, "test_to_double")
			run_test (agent tests.test_to_string, "test_to_string")
			run_test (agent tests.test_to_currency_string, "test_to_currency_string")
			run_test (agent tests.test_dollars_and_cents, "test_dollars_and_cents")
		end

	run_comparison_tests
			-- Run comparison tests
		do
			print ("%N--- Comparison Tests ---%N")
			run_test (agent tests.test_is_less, "test_is_less")
			run_test (agent tests.test_is_equal_decimal, "test_is_equal_decimal")
			run_test (agent tests.test_comparison_operators, "test_comparison_operators")
			run_test (agent tests.test_min_max, "test_min_max")
		end

	run_arithmetic_tests
			-- Run arithmetic tests
		do
			print ("%N--- Arithmetic Tests ---%N")
			run_test (agent tests.test_addition, "test_addition")
			run_test (agent tests.test_subtraction, "test_subtraction")
			run_test (agent tests.test_multiplication, "test_multiplication")
			run_test (agent tests.test_division, "test_division")
			run_test (agent tests.test_integer_division, "test_integer_division")
			run_test (agent tests.test_modulo, "test_modulo")
			run_test (agent tests.test_negate, "test_negate")
			run_test (agent tests.test_absolute, "test_absolute")
			run_test (agent tests.test_power, "test_power")
		end

	run_precision_tests
			-- Run precision tests (THE FAMOUS TEST)
		do
			print ("%N--- Precision Tests ---%N")
			run_test (agent tests.test_point_one_plus_point_two, "test_point_one_plus_point_two")
		end

	run_rounding_tests
			-- Run rounding tests
		do
			print ("%N--- Rounding Tests ---%N")
			run_test (agent tests.test_round_cents, "test_round_cents")
			run_test (agent tests.test_round_to_places, "test_round_to_places")
			run_test (agent tests.test_round_up, "test_round_up")
			run_test (agent tests.test_round_down, "test_round_down")
			run_test (agent tests.test_round_ceiling, "test_round_ceiling")
			run_test (agent tests.test_round_floor, "test_round_floor")
			run_test (agent tests.test_truncate, "test_truncate")
			run_test (agent tests.test_bankers_rounding, "test_bankers_rounding")
		end

	run_financial_tests
			-- Run financial tests
		do
			print ("%N--- Financial Tests ---%N")
			run_test (agent tests.test_percent_of, "test_percent_of")
			run_test (agent tests.test_as_percentage, "test_as_percentage")
			run_test (agent tests.test_from_percentage, "test_from_percentage")
			run_test (agent tests.test_add_percent, "test_add_percent")
			run_test (agent tests.test_subtract_percent, "test_subtract_percent")
			run_test (agent tests.test_split_bill, "test_split_bill")
			run_test (agent tests.test_tax_calculation, "test_tax_calculation")
			run_test (agent tests.test_tip_calculation, "test_tip_calculation")
			run_test (agent tests.test_discount_calculation, "test_discount_calculation")
		end

	run_edge_case_tests
			-- Run edge case tests
		do
			print ("%N--- Edge Case Tests ---%N")
			run_test (agent tests.test_very_large_numbers, "test_very_large_numbers")
			run_test (agent tests.test_very_small_numbers, "test_very_small_numbers")
			run_test (agent tests.test_negative_operations, "test_negative_operations")
			run_test (agent tests.test_chained_operations, "test_chained_operations")
		end

feature {NONE} -- Implementation

	tests: LIB_TESTS
			-- Test set instance

	passed_count: INTEGER
			-- Number of passed tests

	failed_count: INTEGER
			-- Number of failed tests

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and report result
		local
			l_failed: BOOLEAN
		do
			if not l_failed then
				a_test.call (Void)
				print ("  " + a_name + ": PASSED%N")
				passed_count := passed_count + 1
			end
		rescue
			l_failed := True
			print ("  " + a_name + ": FAILED%N")
			failed_count := failed_count + 1
			retry
		end

end
