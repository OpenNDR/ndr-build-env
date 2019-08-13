#ifndef NDR_TEST_SUBCOMP
#define NDR_TEST_SUBCOMP

#ifdef __KERNEL__
#include <linux/printk.h>
#else /* __KERNEL__ */
#include <stdio.h>
#endif /* __KERNEL__ */

/**
 * @def NTS_VALID
 * 	Same as 0
 */
#define NTS_VALID 0

/**
 * @def NTS_VALID
 * 	Same as 1
 */
#define NTS_INVAL 1

/**
 * @def NTS_LOGGER(...)
 * 	Default output method (can be overridden)
 */
#ifndef NTS_LOGGER
#ifdef __KERNEL__
#define NTS_LOGGER(...) \
	printk(KERN_INFO __VA_ARGS__)
#else /* __KERNEL__ */
#define NTS_LOGGER(...) \
	printf(__VA_ARGS__)
#endif /* __KERNEL__ */
#endif /* NTS_LOGGER */

struct nts_internal_testcase
{
	const char *name;
	unsigned long test_cnt;
	unsigned long eval_cnt;
	unsigned long fail_cnt;
	int skip_next;
};
typedef struct nts_internal_testcase nts_tc_t;

static inline int nts_internal_assert(nts_tc_t *tc, const char *expr, unsigned long value1, unsigned long value2)
{
	const int eval = !!(value1 == value2);
	int ret = NTS_VALID;
	tc->test_cnt++;
	if (!(tc->skip_next))
	{
		NTS_LOGGER("%s: %s\n", tc->name, !!eval ? "PASS" : "FAILED");
		NTS_LOGGER("\tEvaluation: %lu == %lu\n", value1, value2);
		NTS_LOGGER("\tExpression: %s\n", expr);
		if (!eval)
		{
			tc->fail_cnt++;
			ret = NTS_INVAL;
		}
		tc->eval_cnt++;
	}
	return ret;
}

static inline void nts_internal_report(nts_tc_t *tc)
{
	NTS_LOGGER("[*] TESTCASE Report\n");
	NTS_LOGGER(" | TC Name   : %s\n", tc->name);
	NTS_LOGGER(" | Testnum   : %lu\n", tc->test_cnt);
	NTS_LOGGER(" | Result    : %s\n", !!(tc->fail_cnt) ? "FAILED" : "PASS");
	NTS_LOGGER(" | Tested    : %lu\n", tc->eval_cnt);
	NTS_LOGGER(" | Passed    : %lu\n", tc->eval_cnt - tc->fail_cnt);
	NTS_LOGGER(" | Failed    : %lu\n", tc->fail_cnt);
	NTS_LOGGER("[*]\n");
}

#define NTS_INTERNAL_STRINGIFY( expr )                 #expr
#define NTS_INTERNAL_TESTEQ_EXPR( expr1, expr2 )       expr1 == expr2
#define NTS_INTERNAL_TESTNE_EXPR( expr1, expr2 )       expr1 != expr2
#define NTS_INTERNAL_TESTLT_EXPR( expr1, expr2 )       expr1 < expr2
#define NTS_INTERNAL_TESTLE_EXPR( expr1, expr2 )       expr1 <= expr2
#define NTS_INTERNAL_TESTGT_EXPR( expr1, expr2 )       expr1 > expr2
#define NTS_INTERNAL_TESTGE_EXPR( expr1, expr2 )       expr1 >= expr2
#define NTS_INTERNAL_STRC(tc) \
	nts_tc_t nts_strc_ ## tc
#define NTS_INTERNAL_INIT(tc) \
	NTS_INTERNAL_STRC(tc) = { \
		.name = NTS_INTERNAL_STRINGIFY(tc), \
		.test_cnt = 0, \
		.eval_cnt = 0, \
		.fail_cnt = 0, \
		.skip_next = 0 \
	}
#define NTS_INTERNAL_ACCESS(tc) \
	(&( nts_strc_ ## tc ))
#define NTS_INTERNAL_FUNC(tc) \
	void nts_func_ ## tc (void)
#define NTS_INTERNAL_ASSERT(tc, expr, value1, value2) \
	nts_internal_assert((tc), NTS_INTERNAL_STRINGIFY(expr), (value1), (value2))

/**
 * @def NTS_DECLARE(tc)
 * 	Macro function to declare test-cases.
 * 	Place in header files.
 */
#define NTS_DECLARE(tc) \
	extern NTS_INTERNAL_STRC(tc); \
	extern NTS_INTERNAL_FUNC(tc)

/**
 * @def NTS_DEFINE(tc)
 * 	Macro function to define test-cases.
 * 	Place in a source file.
 */
#define NTS_DEFINE(tc) \
	NTS_INTERNAL_INIT(tc); \
	NTS_INTERNAL_FUNC(tc)

/**
 * @def NTS_CHECK_EQ(tc)
 * 	Macro function to write check-expressions.
 * 	If two expressions are the same, will return NTS_VALID.
 * 	Else, will return NTS_INVAL.
 */
#define NTS_CHECK_EQ(tc, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTEQ_EXPR(expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2))

/**
 * @def NTS_CHECK_NE(tc)
 * 	Macro function to write check-expressions.
 * 	If two expressions are not the same, will return NTS_VALID.
 * 	Else, will return NTS_INVAL.
 */
#define NTS_CHECK_NE(tc, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTNE_EXPR(expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2))

/**
 * @def NTS_CHECK_LT(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is less than expr2, will return NTS_VALID.
 * 	Else, will return NTS_INVAL.
 */
#define NTS_CHECK_LT(tc, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTLT_EXPR(expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2))

/**
 * @def NTS_CHECK_LE(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is less than or equal to expr2, will return NTS_VALID.
 * 	Else, will return NTS_INVAL.
 */
#define NTS_CHECK_LE(tc, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTLE_EXPR(expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2))

/**
 * @def NTS_CHECK_GT(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is greater than expr2, will return NTS_VALID.
 * 	Else, will return NTS_INVAL.
 */
#define NTS_CHECK_GT(tc, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTGT_EXPR(expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2))

/**
 * @def NTS_CHECK_GE(tc)
 * 	Macro function to write check-expressions.
 * 	If two expr1 is greater than or equal to expr2, will return NTS_VALID.
 * 	If same, will return NTS_INVAL.
 */
#define NTS_CHECK_GE(tc, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTGE_EXPR(expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2))

/**
 * @def NTS_REQUIRE_EQ(tc)
 * 	Macro function to write check-expressions.
 * 	If two expressions are not the same, the test-case will fail immediately.
 */
#define NTS_REQUIRE_EQ(tc, expr1, expr2) \
	if (NTS_CHECK_EQ(tc, expr1, expr2) == NTS_INVAL) \
	{ \
		NTS_INTERNAL_ACCESS(tc)->skip_next = 1; \
	}

/**
 * @def NTS_REQUIRE_NE(tc)
 * 	Macro function to write check-expressions.
 * 	If two expressions are the same, the test-case will fail immediately.
 */
#define NTS_REQUIRE_NE(tc, expr1, expr2) \
	if (NTS_CHECK_NE(tc, expr1, expr2) == NTS_INVAL) \
	{ \
		NTS_INTERNAL_ACCESS(tc)->skip_next = 1; \
	}

/**
 * @def NTS_REQUIRE_LT(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is greater than or equal to expr2, the test-case will fail immediately.
 */
#define NTS_REQUIRE_LT(tc, expr1, expr2) \
	if (NTS_CHECK_LT(tc, expr1, expr2) == NTS_INVAL) \
	{ \
		NTS_INTERNAL_ACCESS(tc)->skip_next = 1; \
	}

/**
 * @def NTS_REQUIRE_LE(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is greater than expr2, the test-case will fail immediately.
 */
#define NTS_REQUIRE_LE(tc, expr1, expr2) \
	if (NTS_CHECK_LE(tc, expr1, expr2) == NTS_INVAL) \
	{ \
		NTS_INTERNAL_ACCESS(tc)->skip_next = 1; \
	}

/**
 * @def NTS_REQUIRE_GT(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is less than or euqal to expr2, the test-case will fail immediately.
 */
#define NTS_REQUIRE_GT(tc, expr1, expr2) \
	if (NTS_CHECK_GT(tc, expr1, expr2) == NTS_INVAL) \
	{ \
		NTS_INTERNAL_ACCESS(tc)->skip_next = 1; \
	}

/**
 * @def NTS_REQUIRE_GE(tc)
 * 	Macro function to write check-expressions.
 * 	If expr1 is less than expr2, the test-case will fail immediately.
 */
#define NTS_REQUIRE_GE(tc, expr1, expr2) \
	if (NTS_CHECK_GE(tc, expr1, expr2) == NTS_INVAL) \
	{ \
		NTS_INTERNAL_ACCESS(tc)->skip_next = 1; \
	}

/**
 * @def NTS_RUN(tc)
 * 	Macro function to run test-cases.
 */
#define NTS_RUN(tc) \
	nts_func_ ## tc ()

/**
 * @def NTS_RUN_RESULT(tc)
 * 	Macro function to get results.
 * 	Will return fail counts.
 */
#define NTS_RESULT(tc) \
	(NTS_INTERNAL_ACCESS(tc)->fail_cnt)

/**
 * @def NTS_REPORT(tc)
 * 	Macro function to print statistics.
 */
#define NTS_REPORT(tc) \
	nts_internal_report(NTS_INTERNAL_ACCESS(tc))

#endif
