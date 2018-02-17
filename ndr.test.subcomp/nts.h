#ifndef NDR_TEST_SUBCOMP
#define NDR_TEST_SUBCOMP

#include <stdio.h>
#include <stdlib.h>

#define __NTS_NULL                  (void *)0

#if defined     __GNUC__
    #define __nts_forceinline__     __attribute__((always_inline))
    #define __nts_likely(x)         __builtin_expect((x),1)
    #define __nts_unlikely(x)       __builtin_expect((x),0)
    #define __NTS_CSTR_FILE         __FILE__
    #define __NTS_CSTR_LINE         __LINE__
    #define __NTS_CSTR_FUNC         __func__
    #define __NTS_CSTR_COMPDATE     __DATE__
    #define __NTS_CSTR_COMPTIME     __TIME__
    #define __NTS_CSTR_FILETIME     __TIMESTAMP__
#elif defined   __clang__
#   if defined  __ICC
#   else
#   endif
#elif defined   _MSC_VER
#else
    #define __nts_forceinline__
    #define __nts_likely(x)         (x)
    #define __nts_unlikely(x)       (x)
    #define __NTS_CSTR_FILE         __NTS_NULL
    #define __NTS_CSTR_LINE         0
    #define __NTS_CSTR_FUNC         __NTS_NULL
    #define __NTS_CSTR_COMPDATE     __NTS_NULL
    #define __NTS_CSTR_COMPTIME     __NTS_NULL
    #define __NTS_CSTR_FILETIME     __NTS_NULL
#endif

#ifdef __nts_forceinline__
    #define __nts_hdrfunc__         static inline __nts_forceinline__
#else
    #define __nts_hdrfunc__         static inline
#endif

#define __NTS_STYLE_RESET       "\x1b[0m"
#define __NTS_FONT_BOLD         "\x1b[1m"
#define __NTS_FONT_ITALICS      "\x1b[3m"
#define __NTS_FONT_UNDERLINE    "\x1b[4m"
#define __NTS_FONT_STRIKETHR    "\x1b[9m"
#define __NTS_COLOR_BLACK       "\x1b[30m"
#define __NTS_COLOR_RED         "\x1b[31m"
#define __NTS_COLOR_GREEN       "\x1b[32m"
#define __NTS_COLOR_YELLOW      "\x1b[33m"
#define __NTS_COLOR_BLUE        "\x1b[34m"
#define __NTS_COLOR_MAGENTA     "\x1b[35m"
#define __NTS_COLOR_CYAN        "\x1b[36m"
#define __NTS_COLOR_WHITE       "\x1b[37m"
#define __NTS_COLOR_RESET       "\x1b[39m"

#define NTS_EXITCODE_PASSED     0
#define NTS_EXITCODE_TFALSE     1
#define NTS_EXITCODE_TCFAIL     2
#define NTS_EXITCODE_TCINTR     3

enum __nts_verbose_level
{
    __NTS_LVLNONE   = 0b000000,
    __NTS_LVLIGN    = 0b000001,
    __NTS_LVLEXPR   = 0b000010,
    __NTS_LVLINFO   = 0b000100,
    __NTS_LVLSPEC   = 0b001000,
    __NTS_LVLCONT   = 0b010000,
    __NTS_LVLEXIT   = 0b100000,
};
typedef enum __nts_verbose_level _NTSLVL_;

#ifdef NBE_STRICT_TEST
    #define __NTS_LVLNORM     __NTS_LVLEXPR | __NTS_LVLINFO | __NTS_LVLEXIT
#else
    #define __NTS_LVLNORM     __NTS_LVLEXPR | __NTS_LVLINFO
#endif

struct __nts_testcase_info
{
    int f_stop;
    int f_spec;
    unsigned long test_cnt;
    unsigned long ignore_cnt;
    unsigned long fail_cnt;
};
typedef struct __nts_testcase_info * _NTSTC_;

__nts_hdrfunc__ void __nts_assert(
    int expr_result, const char *__expr,
    const char * __file, unsigned int __line,
    _NTSTC_ __tc, _NTSLVL_ __verbosity )
{
    if ( __nts_unlikely( __verbosity & __NTS_LVLIGN ) )
    {
        __tc->ignore_cnt++;
        goto assert_out;
    }

    printf( "[#] ");
    if ( __verbosity & __NTS_LVLINFO )
    {
        printf( "%s(%u) : ", __file ? __file : "unkfile", __line );
    }

    printf( "%s%s%s%s\n", __NTS_FONT_BOLD,
        expr_result ? __NTS_COLOR_GREEN : __NTS_COLOR_RED,
        expr_result ? "PASS" : "FAILED", __NTS_STYLE_RESET );

    if ( __verbosity & __NTS_LVLEXPR )
    {
        printf( "\tExpression : %s%s%s\n",
            __NTS_COLOR_CYAN, __expr, __NTS_STYLE_RESET );
    }

    if ( __verbosity & __NTS_LVLSPEC )
    {
        __tc->f_spec = 1;
    }

    if ( !(expr_result) )
    {
        if( !(__verbosity & __NTS_LVLCONT) )
        {
#ifdef NBE_STRICT_TEST
            if ( __verbosity & __NTS_LVLEXIT )
            {
                exit( NTS_EXITCODE_TFALSE );
            }
#endif
            __tc->f_stop = __NTS_LVLIGN;
        }
        __tc->fail_cnt++;
    }

    if ( !(__tc->f_spec) )
    {
        printf( "\n" );
    }

assert_out:
    __tc->test_cnt++;
    return;
}

__nts_hdrfunc__ void __nts_report_tc( const char * __tcn, _NTSTC_ __tc )
{
    double coverage = 0.0;

    printf("%s[*] TESTCASE Coverage report%s\n",
        __NTS_FONT_BOLD, __NTS_STYLE_RESET );
    printf(" %s|%s TC Name  : %s%s%s\n",
        __NTS_FONT_BOLD, __NTS_STYLE_RESET, __NTS_FONT_BOLD,
        __tcn, __NTS_STYLE_RESET );
    printf(" %s|%s Result   : %s%s%s%s\n",
        __NTS_FONT_BOLD, __NTS_STYLE_RESET, __NTS_FONT_BOLD,
        __tc->fail_cnt ? __NTS_COLOR_RED : __NTS_COLOR_GREEN,
        __tc->f_stop ? "INTERRUPTED" : (__tc->fail_cnt ? "FAILED" : "PASS"), __NTS_STYLE_RESET );
    printf(" %s|%s Tested   : %lu%s\n", __NTS_FONT_BOLD, __NTS_STYLE_RESET,
        __tc->test_cnt, __NTS_COLOR_RESET );
    printf(" %s|%s Passed   : %lu%s\n", __NTS_FONT_BOLD, __NTS_STYLE_RESET,
        __tc->test_cnt - __tc->fail_cnt, __NTS_COLOR_RESET );
    printf(" %s|%s Failed   : %lu%s\n",__NTS_FONT_BOLD, __NTS_STYLE_RESET,
        __tc->fail_cnt, __NTS_COLOR_RESET );
    printf(" %s|%s Ignored  : %lu%s\n", __NTS_FONT_BOLD, __NTS_STYLE_RESET,
        __tc->ignore_cnt, __NTS_COLOR_RESET );

    coverage = __tc->f_stop ? -1.0 : (__tc->fail_cnt ? (100 - (100 / (__tc->test_cnt / __tc->fail_cnt))) : 100 );
    if ( coverage < 0 )
    {
        printf(" %s|%s Coverage : %s%s%s%s\n", __NTS_FONT_BOLD, __NTS_STYLE_RESET,
            __NTS_FONT_BOLD, __NTS_COLOR_MAGENTA, "unknown" , __NTS_COLOR_RESET );
    }
    else
    {
        if ( coverage < 30 )
        {
            printf(" %s|%s Coverage : %s%s%.2lf%%%s\n",
                __NTS_FONT_BOLD, __NTS_STYLE_RESET,
                __NTS_FONT_BOLD, __NTS_COLOR_RED, coverage , __NTS_COLOR_RESET );
        }
        else if ( coverage < 70 )
        {
            printf(" %s|%s Coverage : %s%s%.2lf%%%s\n",
                __NTS_FONT_BOLD, __NTS_STYLE_RESET,
                __NTS_FONT_BOLD, __NTS_COLOR_MAGENTA, coverage , __NTS_COLOR_RESET );
        }
        else if ( coverage < 100 )
        {
            printf(" %s|%s Coverage : %s%s%.2lf%%%s\n",
                __NTS_FONT_BOLD, __NTS_STYLE_RESET,
                __NTS_FONT_BOLD, __NTS_COLOR_YELLOW, coverage , __NTS_COLOR_RESET );
        }
        else
        {
            printf(" %s|%s Coverage : %s%s%.2lf%%%s\n",
                __NTS_FONT_BOLD, __NTS_STYLE_RESET,
                __NTS_FONT_BOLD, __NTS_COLOR_GREEN, coverage , __NTS_COLOR_RESET );
        }
    }
    printf("%s[*]%s\n\n", __NTS_FONT_BOLD, __NTS_STYLE_RESET );

#ifdef NBE_STRICT_TEST
    if ( coverage != 100 )
    {
        exit( coverage < 0 ? NTS_EXITCODE_TCFAIL : NTS_EXITCODE_TCINTR );
    }
#endif
}

#define __NTS_STRINGIFY( expr )                 #expr

#define __NTS_TESTEQ_EXPR( expr1, expr2 )       expr1 == expr2

#define __NTS_TC_STRC( testcase )               static struct __nts_testcase_info nts_info_ ## testcase

#define __NTS_TC_FUNC( testcase )               void nts_tc_ ## testcase (void)

#define __NTS_ACCESS_STRC(testcase)             nts_info_ ## testcase

#define __NTS_ASSERT( tc, expr, lvl ) \
    __nts_assert( (expr), __NTS_STRINGIFY(expr), __NTS_CSTR_FILE, __NTS_CSTR_LINE, \
        &(__NTS_ACCESS_STRC(tc)), lvl | (__NTS_ACCESS_STRC(tc)).f_stop )

#define __NTS_DO_SPECULATE( tc, expr1, expr2, expr1_var, expr2_var ) \
    do{ \
        if( (__NTS_ACCESS_STRC(tc)).f_spec ) \
        { \
            (__NTS_ACCESS_STRC(tc)).f_spec = 0; \
            printf( "\tSpeculation result : %s%llu(%s) == %llu(%s)%s\n\n", \
                __NTS_COLOR_CYAN, expr1, expr1_var, \
                expr2, expr2_var, __NTS_STYLE_RESET ); \
        } \
    }while(0);

#define __NTS_SPECULATE( tc, expr1, expr2, lvl ) \
    do{ __NTS_ASSERT( tc, __NTS_TESTEQ_EXPR(expr1, expr2), lvl | __NTS_LVLSPEC ); \
        unsigned long long expr1_var = (unsigned long long)(expr1); \
        unsigned long long expr2_var = (unsigned long long)(expr2); \
        __NTS_DO_SPECULATE( tc, expr1_var, expr2_var, __NTS_STRINGIFY(expr1), __NTS_STRINGIFY(expr2) ); \
    }while(0);

#define NTS_DEFINE_TC( testcase )               __NTS_TC_STRC(testcase) ; __NTS_TC_FUNC(testcase)

#define NTS_DECLARE_TC( testcase )              __NTS_TC_FUNC(testcase)

#define NTS_CALL_TC( testcase )                 nts_tc_ ## testcase ()

#define NTS_REQUIRE( tc, expr )                 __NTS_ASSERT( tc, expr, __NTS_LVLNORM )

#define NTS_CHECK( tc, expr )                   __NTS_ASSERT( tc, expr, __NTS_LVLNORM | __NTS_LVLCONT )

#define NTS_REQUIRE_SPEC( tc, expr1, expr2 )    __NTS_SPECULATE( tc, expr1, expr2, __NTS_LVLNORM )

#define NTS_CHECK_SPEC( tc, expr1, expr2 )      __NTS_SPECULATE( tc, expr1, expr2, __NTS_LVLNORM | __NTS_LVLCONT )

#define NTS_REPORT( tc )                        __nts_report_tc( #tc, &(__NTS_ACCESS_STRC(tc)) )

#endif