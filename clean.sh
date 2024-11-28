#!/bin/bash

awk -F ',' '
	NR==5	||
	NR==7	||
	NR==8	||
	NR==12	||
	NR==13	||
	NR==14	||
	NR==15	||
	NR==16	||
	NR==17	||	
	NR==18	||
	NR==19	||
	NR==22	||	
	NR==23	||	
	NR==24	||
	NR==25	||	
	NR==26	||
	NR==27	||
	NR==28	||	
	NR==29	||
	NR==30	||
	NR==31	||
	NR==36	||
	NR==42	||
	NR==56	||
	NR==57	||
	NR==58	||
	NR==59	||
	NR==60	||
	NR==61	||
	NR==62	||
	NR==82	||
	NR==90 
	{print $0}' "Intel_UPE_ComparisonChart_2024_11_04_i7.csv" |

awk '
{
    for (i=1; i<=NF; i++)  
        a[i] = a[i] ? a[i] "," $i : $i  
}
END {
    for (i=1; i in a; i++)  
        print a[i]
}
' FS=, OFS=, > clean.csv

