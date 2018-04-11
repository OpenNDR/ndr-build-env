#ifndef NDR_TEST_SUBCOMP
#define NDR_TEST_SUBCOMP

#include <stdio.h>
#include <stdlib.h>

#define NTS_INTERNAL_NULL                  (void *)0

#if defined     GNUC
	#define nts_internal_forceinline		__attribute__((always_inline))
	#define nts_internal_likely(x)			__builtin_expect((x),1)
	#define nts_internal_unlikely(x)		__builtin_expect((x),0)
	#define NTS_INTERNAL_CSTR_FILE			__FILE__
	#define NTS_INTERNAL_CSTR_LINE			__LINE__
	#define NTS_INTERNAL_CSTR_FUNC			__func__
	#define NTS_INTERNAL_CSTR_COMPDATE		__DATE__
	#define NTS_INTERNAL_CSTR_COMPTIME		__TIME__
	#define NTS_INTERNAL_CSTR_FILETIME		__TIMESTAMP__
#elif defined   clang
#   if defined  ICC
#   else
#   endif
#elif defined   _MSC_VER
#else
	#define nts_internal_forceinline
	#define nts_internal_likely(x)			(x)
	#define nts_internal_unlikely(x)		(x)
	#define NTS_INTERNAL_CSTR_FILE			NTS_INTERNAL_NULL
	#define NTS_INTERNAL_CSTR_LINE			0
	#define NTS_INTERNAL_CSTR_FUNC			NTS_INTERNAL_NULL
	#define NTS_INTERNAL_CSTR_COMPDATE		NTS_INTERNAL_NULL
	#define NTS_INTERNAL_CSTR_COMPTIME		NTS_INTERNAL_NULL
	#define NTS_INTERNAL_CSTR_FILETIME		NTS_INTERNAL_NULL
#endif

#ifdef nts_internal_forceinline
	#define nts_internal_hdrfunc         static inline nts_internal_forceinline
#else
	#define nts_internal_hdrfunc         static inline
#endif

#define NTS_INTERNAL_STYLE_RESET       "\x1b[0m"
#define NTS_INTERNAL_FONT_BOLD         "\x1b[1m"
#define NTS_INTERNAL_FONT_ITALICS      "\x1b[3m"
#define NTS_INTERNAL_FONT_UNDERLINE    "\x1b[4m"
#define NTS_INTERNAL_FONT_STRIKETHR    "\x1b[9m"
#define NTS_INTERNAL_COLOR_BLACK       "\x1b[30m"
#define NTS_INTERNAL_COLOR_RED         "\x1b[31m"
#define NTS_INTERNAL_COLOR_GREEN       "\x1b[32m"
#define NTS_INTERNAL_COLOR_YELLOW      "\x1b[33m"
#define NTS_INTERNAL_COLOR_BLUE        "\x1b[34m"
#define NTS_INTERNAL_COLOR_MAGENTA     "\x1b[35m"
#define NTS_INTERNAL_COLOR_CYAN        "\x1b[36m"
#define NTS_INTERNAL_COLOR_WHITE       "\x1b[37m"
#define NTS_INTERNAL_COLOR_RESET       "\x1b[39m"

#define NTS_EXITCODE_PASSED     0
#define NTS_EXITCODE_TFALSE     1
#define NTS_EXITCODE_TCFAIL     2
#define NTS_EXITCODE_TCINTR     3

enum nts_internal_verbose_level
{
	NTS_INTERNAL_LVLNONE	= 0b0000000,
	NTS_INTERNAL_LVLIGN		= 0b0000001,
	NTS_INTERNAL_LVLRSLT	= 0b0000010,
	NTS_INTERNAL_LVLINFO	= 0b0000100,
	NTS_INTERNAL_LVLEXPR	= 0b0001000,
	NTS_INTERNAL_LVLSPEC	= 0b0010000,
	NTS_INTERNAL_LVLCONT	= 0b0100000,
	NTS_INTERNAL_LVLEXIT	= 0b1000000,
};
typedef enum nts_internal_verbose_level NTS_LVLENUM;

#ifdef NBE_STRICT_TEST
	#define NTS_LVLNORMAL	NTS_INTERNAL_LVLRSLT | NTS_INTERNAL_LVLINFO | NTS_INTERNAL_LVLEXPR  | NTS_INTERNAL_LVLEXIT
	#define NTS_LVLSIMPLE	NTS_INTERNAL_LVLRSLT | NTS_INTERNAL_LVLINFO | NTS_INTERNAL_LVLEXIT
	#define NTS_LVLRESULT	NTS_INTERNAL_LVLRSLT | NTS_INTERNAL_LVLEXIT
	#define NTS_LVLSILENT	NTS_INTERNAL_LVLEXIT
#else
	#define NTS_LVLNORMAL	NTS_INTERNAL_LVLRSLT | NTS_INTERNAL_LVLINFO | NTS_INTERNAL_LVLEXPR
	#define NTS_LVLSIMPLE	NTS_INTERNAL_LVLRSLT | NTS_INTERNAL_LVLINFO
	#define NTS_LVLRESULT	NTS_INTERNAL_LVLRSLT
	#define NTS_LVLSILENT	NTS_INTERNAL_LVLNONE
#endif

struct nts_internal_testcase_info
{
	int f_stop;
	int f_spec;
	unsigned long test_cnt;
	unsigned long ignore_cnt;
	unsigned long fail_cnt;
};
typedef struct nts_internal_testcase_info * NTS_STRUCT;

nts_internal_hdrfunc void nts_internal_assert(
	int expr_result, const char *expr,
	const char * file, unsigned int line,
	NTS_STRUCT tc, NTS_LVLENUM verbosity )
{
	if ( nts_internal_unlikely( verbosity & NTS_INTERNAL_LVLIGN ) )
	{
		tc->ignore_cnt++;
		goto assert_out;
	}

	if ( verbosity & NTS_INTERNAL_LVLRSLT )
	{
		printf( "[#] ");
	}

	if ( verbosity & NTS_INTERNAL_LVLINFO )
	{
		printf( "%s(%u) : ", file ? file : "unkfile", line );
	}

	if ( verbosity & NTS_INTERNAL_LVLRSLT )
	{
		printf( "%s%s%s%s\n", NTS_INTERNAL_FONT_BOLD,
			expr_result ? NTS_INTERNAL_COLOR_GREEN : NTS_INTERNAL_COLOR_RED,
			expr_result ? "PASS" : "FAILED", NTS_INTERNAL_STYLE_RESET );
	}

	if ( verbosity & NTS_INTERNAL_LVLEXPR )
	{
		printf( "\tExpression : %s%s%s\n",
			NTS_INTERNAL_COLOR_CYAN, expr, NTS_INTERNAL_STYLE_RESET );
	}

	if ( verbosity & NTS_INTERNAL_LVLSPEC )
	{
		tc->f_spec = 1;
	}

	if ( !(expr_result) )
	{
		if( !(verbosity & NTS_INTERNAL_LVLCONT) )
		{
#ifdef NBE_STRICT_TEST
			if ( verbosity & NTS_INTERNAL_LVLEXIT )
			{
				exit( NTS_EXITCODE_TFALSE );
			}
#endif
			tc->f_stop = NTS_INTERNAL_LVLIGN;
		}
		tc->fail_cnt++;
	}

	if ( !(tc->f_spec) && (verbosity & NTS_INTERNAL_LVLRSLT) )
	{
		printf( "\n" );
	}

assert_out:
	tc->test_cnt++;
	return;
}

nts_internal_hdrfunc void nts_internal_report_tc( const char * tcn, NTS_STRUCT tc )
{
	double pass_rate = 0.0;

	printf("\n%s[*] TESTCASE Report%s\n",
		NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET );
	printf(" %s|%s TC Name   : %s%s%s\n",
		NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET, NTS_INTERNAL_FONT_BOLD,
		tcn, NTS_INTERNAL_STYLE_RESET );
	printf(" %s|%s Result    : %s%s%s%s\n",
		NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET, NTS_INTERNAL_FONT_BOLD,
		tc->fail_cnt ? NTS_INTERNAL_COLOR_RED : NTS_INTERNAL_COLOR_GREEN,
		tc->f_stop ? "INTERRUPTED" : (tc->fail_cnt ? "FAILED" : "PASS"), NTS_INTERNAL_STYLE_RESET );
	printf(" %s|%s Tested    : %lu%s\n", NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
		tc->test_cnt, NTS_INTERNAL_COLOR_RESET );
	printf(" %s|%s Passed    : %lu%s\n", NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
		tc->test_cnt - tc->fail_cnt, NTS_INTERNAL_COLOR_RESET );
	printf(" %s|%s Failed    : %lu%s\n",NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
		tc->fail_cnt, NTS_INTERNAL_COLOR_RESET );
	printf(" %s|%s Ignored   : %lu%s\n", NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
		tc->ignore_cnt, NTS_INTERNAL_COLOR_RESET );

	if ( tc->f_stop )
	{
		pass_rate = -1.0;
	}
	else
	{
		if ( tc->fail_cnt )
		{
			pass_rate = (tc->test_cnt ^ tc->fail_cnt) ?  (100.0 - ((tc->fail_cnt * 100.0) / tc->test_cnt)) : 0.0;
		}
		else
		{
			pass_rate = 100.0;
		}
	}

	if ( pass_rate < 0 )
	{
		printf(" %s|%s Pass Rate : %s%s%s%s\n", NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
			NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_COLOR_MAGENTA, "unknown" , NTS_INTERNAL_COLOR_RESET );
	}
	else
	{
		if ( pass_rate < 30 )
		{
			printf(" %s|%s Pass Rate : %s%s%.2lf%%%s\n",
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_COLOR_RED, pass_rate , NTS_INTERNAL_COLOR_RESET );
		}
		else if ( pass_rate < 70 )
		{
			printf(" %s|%s Pass Rate : %s%s%.2lf%%%s\n",
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_COLOR_MAGENTA, pass_rate , NTS_INTERNAL_COLOR_RESET );
		}
		else if ( pass_rate < 100 )
		{
			printf(" %s|%s Pass Rate : %s%s%.2lf%%%s\n",
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_COLOR_YELLOW, pass_rate , NTS_INTERNAL_COLOR_RESET );
		}
		else
		{
			printf(" %s|%s Pass Rate : %s%s%.2lf%%%s\n",
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET,
				NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_COLOR_GREEN, pass_rate , NTS_INTERNAL_COLOR_RESET );
		}
	}
	printf("%s[*]%s\n\n", NTS_INTERNAL_FONT_BOLD, NTS_INTERNAL_STYLE_RESET );

#ifdef NBE_STRICT_TEST
	if ( pass_rate != 100 )
	{
		exit( pass_rate < 0 ? NTS_EXITCODE_TCFAIL : NTS_EXITCODE_TCINTR );
	}
#endif
}

#define NTS_INTERNAL_STRINGIFY( expr )                 #expr

#define NTS_INTERNAL_TESTEQ_EXPR( expr1, expr2 )       expr1 == expr2

#define NTS_INTERNAL_TC_STRC( testcase )               struct nts_internal_testcase_info nts_info_ ## testcase

#define NTS_INTERNAL_TC_FUNC( testcase )               void nts_tc_ ## testcase (void)

#define NTS_INTERNAL_ACCESS_STRC(testcase)             nts_info_ ## testcase

#define NTS_INTERNAL_ASSERT( tc, expr, lvl ) \
	nts_internal_assert( (expr), NTS_INTERNAL_STRINGIFY(expr), NTS_INTERNAL_CSTR_FILE, NTS_INTERNAL_CSTR_LINE, \
		&(NTS_INTERNAL_ACCESS_STRC(tc)), lvl | (NTS_INTERNAL_ACCESS_STRC(tc)).f_stop )

#define NTS_INTERNAL_DO_SPECULATE( tc, expr1, expr2, expr1_var, expr2_var ) \
	do{ \
		if( (NTS_INTERNAL_ACCESS_STRC(tc)).f_spec ) \
		{ \
			(NTS_INTERNAL_ACCESS_STRC(tc)).f_spec = 0; \
			printf( "\tSpeculation result : %s%llu(%s) == %llu(%s)%s\n\n", \
				NTS_INTERNAL_COLOR_CYAN, expr1, expr1_var, \
				expr2, expr2_var, NTS_INTERNAL_STYLE_RESET ); \
		} \
	}while(0);

#define NTS_INTERNAL_SPECULATE( tc, expr1, expr2, lvl ) \
	do{ NTS_INTERNAL_ASSERT( tc, NTS_INTERNAL_TESTEQ_EXPR(expr1, expr2), lvl | NTS_INTERNAL_LVLSPEC ); \
		unsigned long long expr1_var = (unsigned long long)(expr1); \
		unsigned long long expr2_var = (unsigned long long)(expr2); \
		NTS_INTERNAL_DO_SPECULATE( tc, expr1_var, expr2_var, NTS_INTERNAL_STRINGIFY(expr1), NTS_INTERNAL_STRINGIFY(expr2) ); \
	}while(0);

#define NTS_DECLARE_TC( testcase )						extern NTS_INTERNAL_TC_STRC(testcase) ; NTS_INTERNAL_TC_FUNC(testcase)

#define NTS_DEFINE_TC( testcase )						NTS_INTERNAL_TC_STRC(testcase) ; NTS_INTERNAL_TC_FUNC(testcase)

#define NTS_CALL_TC( testcase )							nts_tc_ ## testcase ()

#define NTS_REQUIRE( tc, expr )							NTS_INTERNAL_ASSERT( tc, expr, NTS_LVLNORMAL )

#define NTS_CHECK( tc, expr )							NTS_INTERNAL_ASSERT( tc, expr, NTS_LVLNORMAL | NTS_INTERNAL_LVLCONT )

#define NTS_REQUIRE_SPEC( tc, expr1, expr2 )			NTS_INTERNAL_SPECULATE( tc, expr1, expr2, NTS_LVLNORMAL )

#define NTS_CHECK_SPEC( tc, expr1, expr2 )				NTS_INTERNAL_SPECULATE( tc, expr1, expr2, NTS_LVLNORMAL | NTS_INTERNAL_LVLCONT )

#define NTS_REQUIRE_LVL( tc, expr, lvl )				NTS_INTERNAL_ASSERT( tc, expr, lvl )

#define NTS_CHECK_LVL( tc, expr, lvl )					NTS_INTERNAL_ASSERT( tc, expr, lvl | NTS_INTERNAL_LVLCONT )

#define NTS_REQUIRE_SPEC_LVL( tc, expr1, expr2, lvl )	NTS_INTERNAL_SPECULATE( tc, expr1, expr2, lvl )

#define NTS_CHECK_SPEC_LVL( tc, expr1, expr2, lvl )		NTS_INTERNAL_SPECULATE( tc, expr1, expr2, lvl | NTS_INTERNAL_LVLCONT )

#define NTS_REPORT( tc )								nts_internal_report_tc( #tc, &(NTS_INTERNAL_ACCESS_STRC(tc)) )

#endif