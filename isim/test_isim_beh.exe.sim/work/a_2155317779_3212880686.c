/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/Miguel/Desktop/CR/projectv4/RNG.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );


static void work_a_2155317779_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    int t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    int t15;
    int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned char t20;

LAB0:    xsi_set_current_line(49, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    xsi_set_current_line(60, ng0);
    t1 = (t0 + 1888U);
    t3 = *((char **)t1);
    t1 = (t0 + 3576);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t3, 10U);
    xsi_driver_first_trans_fast_port(t1);
    t1 = (t0 + 3432);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(50, ng0);
    t3 = (t0 + 2128U);
    t4 = *((char **)t3);
    t5 = *((int *)t4);
    t6 = (t5 < 216);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(57, ng0);
    t1 = (t0 + 3512);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);

LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(51, ng0);
    t3 = (t0 + 3512);
    t7 = (t3 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t3);
    xsi_set_current_line(52, ng0);
    t1 = (t0 + 1888U);
    t3 = *((char **)t1);
    t5 = (10 - 1);
    t11 = (t5 - 9);
    t12 = (t11 * -1);
    t13 = (1U * t12);
    t14 = (0 + t13);
    t1 = (t3 + t14);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 1888U);
    t7 = *((char **)t4);
    t15 = (10 - 2);
    t16 = (t15 - 9);
    t17 = (t16 * -1);
    t18 = (1U * t17);
    t19 = (0 + t18);
    t4 = (t7 + t19);
    t6 = *((unsigned char *)t4);
    t20 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t2, t6);
    t8 = (t0 + 2008U);
    t9 = *((char **)t8);
    t8 = (t9 + 0);
    *((unsigned char *)t8) = t20;
    xsi_set_current_line(53, ng0);
    t1 = (t0 + 1888U);
    t3 = *((char **)t1);
    t5 = (10 - 2);
    t12 = (9 - t5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t1 = (t3 + t14);
    t4 = xsi_get_transient_memory(9U);
    memcpy(t4, t1, 9U);
    t7 = (t0 + 1888U);
    t8 = *((char **)t7);
    t11 = (10 - 1);
    t17 = (9 - t11);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t7 = (t8 + t19);
    memcpy(t7, t4, 9U);
    xsi_set_current_line(54, ng0);
    t1 = (t0 + 2008U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 1888U);
    t4 = *((char **)t1);
    t5 = (0 - 9);
    t12 = (t5 * -1);
    t13 = (1U * t12);
    t14 = (0 + t13);
    t1 = (t4 + t14);
    *((unsigned char *)t1) = t2;
    xsi_set_current_line(55, ng0);
    t1 = (t0 + 2128U);
    t3 = *((char **)t1);
    t5 = *((int *)t3);
    t11 = (t5 + 1);
    t1 = (t0 + 2128U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t11;
    goto LAB6;

}


extern void work_a_2155317779_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2155317779_3212880686_p_0};
	xsi_register_didat("work_a_2155317779_3212880686", "isim/test_isim_beh.exe.sim/work/a_2155317779_3212880686.didat");
	xsi_register_executes(pe);
}
