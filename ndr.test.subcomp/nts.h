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

enum nts_internal_evaltype
{
	NTS_INTERNAL_EVAL_EQ,
	NTS_INTERNAL_EVAL_NE,
	NTS_INTERNAL_EVAL_LT,
	NTS_INTERNAL_EVAL_LE,
	NTS_INTERNAL_EVAL_GT,
	NTS_INTERNAL_EVAL_GE,
};
typedef enum nts_internal_evaltype nts_eval_t;

struct nts_internal_testcase
{
	const char *name;
	unsigned long test_cnt;
	unsigned long eval_cnt;
	unsigned long fail_cnt;
	int skip_next;
};
typedef struct nts_internal_testcase nts_tc_t;

static inline int nts_internal_assert(nts_tc_t *tc, const char *expr,
		unsigned long value1, unsigned long value2, nts_eval_t eval_type )
{
	int eval;
	int ret = NTS_VALID;

	switch ( eval_type )
	{
		case NTS_INTERNAL_EVAL_EQ:
			eval = !!(value1 == value2);
			break;
		case NTS_INTERNAL_EVAL_NE:
			eval = !!(value1 != value2);
			break;
		case NTS_INTERNAL_EVAL_LT:
			eval = !!(value1 < value2);
			break;
		case NTS_INTERNAL_EVAL_LE:
			eval = !!(value1 <= value2);
			break;
		case NTS_INTERNAL_EVAL_GT:
			eval = !!(value1 > value2);
			break;
		case NTS_INTERNAL_EVAL_GE:
			eval = !!(value1 >= value2);
			break;
	}

	tc->test_cnt++;
	if (!(tc->skip_next))
	{
		NTS_LOGGER("%s: %s\n", tc->name, !!eval ? "PASS" : "FAILED");
		NTS_LOGGER("\tEvaluation: %lu, %lu\n", value1, value2);
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
#define NTS_INTERNAL_TESTEXPR_EQ( expr1, expr2 )       expr1 == expr2
#define NTS_INTERNAL_TESTEXPR_NE( expr1, expr2 )       expr1 != expr2
#define NTS_INTERNAL_TESTEXPR_LT( expr1, expr2 )       expr1 < expr2
#define NTS_INTERNAL_TESTEXPR_LE( expr1, expr2 )       expr1 <= expr2
#define NTS_INTERNAL_TESTEXPR_GT( expr1, expr2 )       expr1 > expr2
#define NTS_INTERNAL_TESTEXPR_GE( expr1, expr2 )       expr1 >= expr2
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
#define NTS_INTERNAL_ASSERT(tc, expr, value1, value2, cond) \
	nts_internal_assert((tc), NTS_INTERNAL_STRINGIFY(expr), \
			(value1), (value2), NTS_INTERNAL_EVAL_ ##cond )

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
 * @def NTS_CHECK(tc, cond, expr1, expr2)
 * 	Macro function to write check-expressions.
 * 	If two expressions are valid to a condition, will return NTS_VALID.
 * 	Else, will return NTS_INVAL.
 */
#define NTS_CHECK(tc, cond, expr1, expr2) \
	NTS_INTERNAL_ASSERT(NTS_INTERNAL_ACCESS(tc), \
		NTS_INTERNAL_TESTEXPR_ ##cond (expr1, expr2), \
		(unsigned long)(expr1), (unsigned long)(expr2), cond)

/**
 * @def NTS_REQUIRE_EQ(tc, cond, expr1, expr2)
 * 	Macro function to write check-expressions.
 * 	If two expressions are violate a condition, the test-case will fail immediately.
 */
#define NTS_REQUIRE(tc, expr1, expr2, cond) \
	if (NTS_CHECK(tc, expr1, expr2, cond) == NTS_INVAL) \
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
