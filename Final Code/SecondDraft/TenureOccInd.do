

* tenure and occ ind variable construction



clear all


do "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_TENURE/J355384.do"

do "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_TENURE/J355384_formats.do"




gen personid = (ER30001*1000)+ER30002 
gen head1968=0
gen head1969=0
gen head1970=0
gen head1971=0
gen head1972=0
gen head1973=0
gen head1974=0
gen head1975=0
gen head1976=0
gen head1977=0
gen head1978=0
gen head1979=0
gen head1980=0
gen head1981=0
gen head1982=0
gen head1983=0
gen head1984=0
gen head1985=0
gen head1986=0
gen head1987=0
gen head1988=0
gen head1989=0
gen head1990=0
gen head1991=0
gen head1992=0
gen head1993=0
gen head1994=0
gen head1995=0
gen head1996=0
gen head1997=0
gen head1999=0
gen head2001=0
gen head2003=0
gen head2005=0
gen head2007=0
gen head2009=0
gen head2011=0
gen head2013=0
gen head2015=0
gen head2017=0
gen head2019=0
gen head2021=0
gen head2023=0


replace head1968=1 if ER30003  ==1
replace head1969=1 if ER30022  ==1
replace head1970=1 if ER30045  ==1
replace head1971=1 if ER30069  ==1
replace head1972=1 if ER30093  ==1
replace head1973=1 if ER30119  ==1
replace head1974=1 if ER30140  ==1
replace head1975=1 if ER30162  ==1
replace head1976=1 if ER30190  ==1
replace head1977=1 if ER30219  ==1
replace head1978=1 if ER30248  ==1
replace head1979=1 if ER30285  ==1
replace head1980=1 if ER30315  ==1
replace head1981=1 if ER30345  ==1
replace head1982=1 if ER30375  ==1
replace head1983=1 if ER30401  ==10
replace head1984=1 if ER30431  ==10
replace head1985=1 if ER30465  ==10
replace head1986=1 if ER30500  ==10
replace head1987=1 if ER30537  ==10
replace head1988=1 if ER30572  ==10
replace head1989=1 if ER30608  ==10
replace head1990=1 if ER30644  ==10
replace head1991=1 if ER30691  ==10
replace head1992=1 if ER30735  ==10
replace head1993=1 if ER30808  ==10
replace head1994=1 if ER33103  ==10
replace head1995=1 if ER33203  ==10
replace head1996=1 if ER33303  ==10
replace head1997=1 if ER33403  ==10
replace head1999=1 if ER33503  ==10
replace head2001=1 if ER33603  ==10
replace head2003=1 if ER33703  ==10
replace head2005=1 if ER33803  ==10
replace head2007=1 if ER33903  ==10
replace head2009=1 if ER34003  ==10
replace head2011=1 if ER34103  ==10
replace head2013=1 if ER34203  ==10
replace head2015=1 if ER34303  ==10
replace head2017=1 if ER34503  ==10
replace head2019=1 if ER34703  ==10
replace head2021=1 if ER34903  ==10
replace head2023=1 if ER35103  ==10



gen tenure1970 =.
gen tenure1971 =.
gen tenure1972 =.
gen tenure1973 =.
gen tenure1974 =.
gen tenure1975 =.
gen tenure1976 =.
gen tenure1977 =.
gen tenure1978 =.
gen tenure1979 =.
gen tenure1980 =.
gen tenure1981 =.
gen tenure1982 =.
gen tenure1983 =.
gen tenure1984 =.
gen tenure1985 =.
gen tenure1986 =.
gen tenure1987 =.
gen tenure1988 =.
gen tenure1989 =.
gen tenure1990 =.
gen tenure1991 =.
gen tenure1992 =.
gen tenure1993 =.
gen tenure1994 =.
gen tenure1995 =.
gen tenure1996 =.
gen tenure1997 =.
gen tenure1999 =.
gen tenure2001 =.
gen tenure2003 =.
gen tenure2005 =.
gen tenure2007 =.
gen tenure2009 =.
gen tenure2011 =.
gen tenure2013 =.
gen tenure2015 =.
gen tenure2017 =.
gen tenure2019 =.
gen tenure2021 =.
gen tenure2023 =.





replace tenure1970 = 0 if head1970==1 & (V1281==0|V1281==1)
replace tenure1970 = 1 if head1970==1 & V1281==2
replace tenure1971 = 0 if head1971==1 & (V1987==0|V1987==1)
replace tenure1971 = 1 if head1971==1 & V1987==2
replace tenure1972 = 0 if head1972==1 & (V2585==0|V2585==1)
replace tenure1972 = 1 if head1972==1 & V2585==2
replace tenure1973 = 0 if head1973==1 & (V3118==0|V3118==1)
replace tenure1973 = 1 if head1973==1 & V3118==2
replace tenure1974 = 0 if head1974==1 & (V3533==0|V3533==1)
replace tenure1974 = 1 if head1974==1 & V3533==2
replace tenure1975 = 0  if head1975==1 & (V3984==0|V3984==1)
replace tenure1975 = 1  if head1975==1 & V3984==2





replace tenure1976 = floor(V4488/12) if head1976==1 & V4488!=. & V4488<98
replace tenure1977 = floor(V5397/12) if head1977==1 & V5397!=. & V5397<998
replace tenure1978 = floor(V5888/12) if head1978==1 & V5888!=. & V5888<998
replace tenure1979 = floor(V6499/12) if head1979==1 & V6499!=. & V6499<998
replace tenure1980 = floor(V7102/12) if head1980==1 & V7102!=. & V7102<998
replace tenure1981 = floor(V7722/12) if head1981==1 & V7722!=. & V7722<998
replace tenure1982 = floor(V8390/12) if head1982==1 & V8390!=. & V8390<998
replace tenure1983 = floor(V9021/12) if head1983==1 & V9021!=. & V9021<998
replace tenure1984 = floor(V10520/12) if head1984==1 & V10520!=. & V10520<998
replace tenure1985 = floor(V11669/12) if head1985==1 & V11669!=. & V11669<998
replace tenure1986 = floor(V13069/12) if head1986==1 & V13069!=. & V13069<998
replace tenure1987 = floor(V14167/12) if head1987==1 & V14167!=. & V14167<998






replace tenure1988 = 1 if head1988==1 & V15191==87
replace tenure1988 = 0 if head1988==1 & V15191==88

replace tenure1989 = 1 if head1989==1 & V16692==88
replace tenure1989 = 0 if head1989==1 & V16692==89

replace tenure1990 = 1 if head1990==1 & V18130==89
replace tenure1990 = 0 if head1990==1 & V18130==90

replace tenure1991 = 1 if head1991==1 & V19430==90
replace tenure1991 = 0 if head1991==1 & V19430==91

replace tenure1992 = 1 if head1992==1 & V20730==91
replace tenure1992 = 0 if head1992==1 & V20730==92

replace tenure1993 = 1 if head1993==1 & V22499==1992
replace tenure1993 = 0 if head1993==1 & V22499==1993





replace tenure1994 = 94-ER2110 if head1994==1 & ER2110!=. & ER2110<95
replace tenure1994 = 0 if head1994==1 & ER2110==0
replace tenure1994 = 1 if head1994==1 & ER2110==96
replace tenure1995 = 1995-ER5109 if head1995==1 & ER5109!=. & ER5109<1996
replace tenure1995 = 0 if head1995==1 & ER5109==0
replace tenure1995 = 1 if head1995==1 & ER5109==9996
replace tenure1996 = 1996-ER7205 if head1996==1 & ER7205!=. & ER7205<1997
replace tenure1996 = 0 if head1996==1 & ER7205==0
replace tenure1996 = 1 if head1996==1 & ER7205==9996
replace tenure1997 = 1997-ER10129 if head1997==1 & ER10129!=. & ER10129<1998
replace tenure1997 = 0 if head1997==1 & ER10129==0
replace tenure1997 = 1 if head1997==1 & ER10129==9996
replace tenure1999 = 1999-ER13255 if head1999==1 & ER13255!=. & ER13255<2000
replace tenure1999 = 0 if head1999==1 & ER13255==0
replace tenure2001 = 2001-ER17266 if head2001==1 & ER17266!=. & ER17266<2002
replace tenure2001 = 0 if head2001==1 & ER17266==0
replace tenure2001 = 1 if head2001==1 & ER17266==9996






replace tenure2003 = 2003-ER21130 if head2003==1 & ER21130!=. & ER21130<2004
replace tenure2003 = 0 if head2003==1 & ER21130==0
replace tenure2005 = 2005-ER25112 if head2005==1 & ER25112!=. & ER25112<2006
replace tenure2005 = 0 if head2005==1 & ER25112==0
replace tenure2007 = 2007-ER36117 if head2007==1 & ER36117!=. & ER36117<2008
replace tenure2007 = 0 if head2007==1 & ER36117==0
replace tenure2009 = 2009-ER42152 if head2009==1 & ER42152!=. & ER42152<2010
replace tenure2009 = 0 if head2009==1 & ER42152==0
replace tenure2009 = 1 if head2009==1 & ER42152==9996
replace tenure2011 = 2011-ER47464 if head2011==1 & ER47464!=. & ER47464<2012
replace tenure2011 = 0 if head2011==1 & ER47464==0
replace tenure2011 = 1 if head2011==1 & ER47464==9996
replace tenure2013 = 2013-ER53164 if head2013==1 & ER53164!=. & ER53164<2014
replace tenure2013 = 0 if head2013==1 & ER53164==0
replace tenure2013 = 1 if head2013==1 & ER53164==9996
replace tenure2015 = 2015-ER60179 if head2015==1 & ER60179!=. & ER60179<2016
replace tenure2015 = 0 if head2015==1 & ER60179==0
replace tenure2015 = 1 if head2015==1 & ER60179==9996
replace tenure2017 = 2017-ER66180 if head2017==1 & ER66180!=. & ER66180<2018
replace tenure2017 = 0 if head2017==1 & ER66180==0
replace tenure2017 = 1 if head2017==1 & ER66180==9996
replace tenure2019 = 2019-ER72180 if head2019==1 & ER72180!=. & ER72180<2020
replace tenure2019 = 0 if head2019==1 & ER72180==0
replace tenure2019 = 1 if head2019==1 & ER72180==9996
replace tenure2021 = 2021-ER78183 if head2021==1 & ER78183!=. & ER78183<2022
replace tenure2021 = 0 if head2021==1 & ER78183==0
replace tenure2021 = 1 if head2021==1 & ER78183==9996
replace tenure2023 = 2023-ER82166 if head2023==1 & ER82166!=. & ER82166<2024
replace tenure2023 = 0 if head2023==1 & ER82166==0
replace tenure2023 = 1 if head2023==1 & ER82166==9996






gen tenurex1970=V1281 if head1970==1
gen tenurex1971=V1987 if head1971==1
gen tenurex1972=V2585 if head1972==1
gen tenurex1973=V3118 if head1973==1
gen tenurex1974=V3533 if head1974==1
gen tenurex1975=V3984 if head1975==1
gen tenurey1976=V4488 if head1976==1
gen tenurez1989=V16692 if head1989==1
gen tenurez1990=V18130 if head1990==1
gen tenurez1991=V19430 if head1991==1
gen tenurez1992=V20730 if head1992==1
gen tenurez1993=V22499 if head1993==1

keep personid tenure*
reshape long tenure tenurex tenurey tenurez, i(personid) j(year)




tsset personid year
sort personid year

*this piece is only defined for 1970-1975*
replace tenure=2 if tenure==. & tenurex==3 & F.tenurex==3
replace tenure=3 if tenure==. & tenurex==3 & F.tenurex==4
replace tenure=4 if tenure==. & tenurex==4 & L.tenurex==3
replace tenure=9 if tenure==. & tenurex==4 & F.tenurex==5
replace tenure=10 if tenure==. & tenurex==5 & L.tenurex==4
replace tenure=19 if tenure==. & tenurex==5 & F.tenurex==6
replace tenure=20 if tenure==. & tenurex==6 & L.tenurex==5


replace tenure=F.tenure-1   if tenure==. & F.tenure!=.   & F.tenure>1   & year<1976
replace tenure=F2.tenure-2 if tenure==. & F2.tenure!=. & F2.tenure>2 & year<1976
replace tenure=F3.tenure-3 if tenure==. & F3.tenure!=. & F3.tenure>3 & year<1976
replace tenure=F4.tenure-4 if tenure==. & F4.tenure!=. & F4.tenure>4 & year<1976
replace tenure=F5.tenure-5 if tenure==. & F5.tenure!=. & F5.tenure>5 & year<1976
replace tenure=F.tenure-1   if tenure==. & F.tenure!=.   & F.tenure>1 & year<1976
replace tenure=F2.tenure-2 if tenure==. & F2.tenure!=. & F2.tenure>2 & year<1976
replace tenure=F.tenure-1   if tenure==. & F.tenure!=.   & F.tenure>1 & year<1976
replace tenure=F2.tenure-2 if tenure==. & F2.tenure!=. & F2.tenure>2 & year<1976
replace tenure=F.tenure-1   if tenure==. & F.tenure!=.   & F.tenure>1 & year<1976
replace tenure=F2.tenure-2 if tenure==. & F2.tenure!=. & F2.tenure>2 & year<1976

*this piece is only defined for 1976*
replace tenure=max(8,L.tenure+1)  if tenure==. & L.tenure!=.  & tenurey==98 
replace tenure=max(8,L2.tenure+2) if tenure==. & L2.tenure!=. & tenurey==98
replace tenure=max(8,L3.tenure+3) if tenure==. & L3.tenure!=. & tenurey==98
replace tenure=max(8,L4.tenure+4) if tenure==. & L4.tenure!=. & tenurey==98
replace tenure=max(8,L5.tenure+5) if tenure==. & L5.tenure!=. & tenurey==98
replace tenure=max(8,L6.tenure+6) if tenure==. & L6.tenure!=. & tenurey==98


save "C:\data\EarningsVolatility\PSIDdata\Tenure\tenure.dta", replace







gen tenurew=tenure
move tenurew tenurex

** Using original tenure, but limited by age, where age was originally dubious
** for that reason

replace tenure=. if tenure<0
replace tenure=max(min(tenurew, currentage-16),0) if tenurew!=.


** Obvious interpolations

replace tenure = L.tenure+1   if tenure==. & F.tenure-L.tenure    == 2 & F.tenure   !=.  & L.tenure  !=.
replace tenure = L2.tenure+2 if tenure==. & F.tenure-L2.tenure  == 3 & F.tenure   !=.  & L2.tenure !=.
replace tenure = L.tenure+1   if tenure==. & F2.tenure-L.tenure  == 3 & F2.tenure !=.  & L.tenure  !=.
replace tenure = L2.tenure+2 if tenure==. & F2.tenure-L2.tenure == 4 & F2.tenure !=.  & L2.tenure !=.


* Filling in missing data consistently with future data

	forvalues z=1(1)43 {
		replace tenure=F`z'.tenure-`z' if tenure==. & F`z'.tenure!=. & F`z'.tenure>=`z'
	}

replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0

* this piece is only defined for 1976 
replace tenure=max(8,L.tenure+1)  if tenure==. & L.tenure!=.  & tenurey==98 
replace tenure=max(8,L2.tenure+2) if tenure==. & L2.tenure!=. & tenurey==98
replace tenure=max(8,L3.tenure+3) if tenure==. & L3.tenure!=. & tenurey==98
replace tenure=max(8,L4.tenure+4) if tenure==. & L4.tenure!=. & tenurey==98
replace tenure=max(8,L5.tenure+5) if tenure==. & L5.tenure!=. & tenurey==98
replace tenure=max(8,L6.tenure+6) if tenure==. & L6.tenure!=. & tenurey==98
replace tenure=8 if tenure==. & tenurey==98


*this piece is only defined for 1988-1993*
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999

* Setting tenure=0 for people known not to have a job this/last

replace tenure=0 if unemp==1
replace tenure=0 if OLF==1

* No earnings/hours/weeks last year or this year 
replace tenure=0 if tenure==. & annhrs==0
replace tenure=0 if tenure==. & weeks==0
replace tenure=0 if tenure==. & earnings==0
replace tenure=0 if tenure==. & F.annhrs==0
replace tenure=0 if tenure==. & F.weeks==0
replace tenure=0 if tenure==. & F.earnings==0

* Making sure that tenure is small for workers known to be
* new to their jobs

replace tenure=1 if tenure!=. & tenure>1 & L.tenure==0
replace tenure=2 if tenure!=. & tenure>1 & L2.tenure==0
replace tenure=2 if tenure!=. & tenure>2 & L.tenure==1

*this piece is only defined for 1988-1993*
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999

* Filling in missing data consistently with future data
	replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0

forvalues z=1(1)10 {
	replace tenure=F`z'.tenure-`z' if tenure==. & F`z'.tenure!=. & F`z'.tenure>=`z'
}

replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0



* if tenure is still missing, infer tenure=0 if occ/ind don't match last report
	replace tenure=0 if tenure==. & occ!=. & occ!=0 & occ!=999 & occ!=.m & occ!=.s & L.occ!=. & L.occ!=0 & L.occ!=999 & L.occ!=.m & L.occ!=.s & occ!=L.occ
	replace tenure=0 if tenure==. & occ!=. & occ!=0 & occ!=999 & occ!=.m & occ!=.s & L2.occ!=. & L2.occ!=0 & L2.occ!=999 & L2.occ!=.m & L2.occ!=.s & occ!=L2.occ & year>1997
	replace tenure=0 if tenure==. & twoind!=. & twoind!=0 & twoind!=999 & twoind!=.m & twoind!=.s & L.twoind!=. & L.twoind!=0 & L.twoind!=999 & L.twoind!=.m & L.twoind!=.s & twoind!=L.twoind
	replace tenure=0 if tenure==. & twoind!=. & twoind!=0 & twoind!=999 & twoind!=.m & twoind!=.s & L2.twoind!=. & L2.twoind!=0 & L2.twoind!=999 & L2.twoind!=.m & L2.twoind!=.s & twoind!=L2.twoind & year>1997
	replace tenure=0 if tenure==. & oneind!=. & oneind!=0 & oneind!=999 & oneind!=.m & oneind!=.s & L.oneind!=. & L.oneind!=0 & L.oneind!=999 & L.oneind!=.m & L.oneind!=.s & oneind!=L.oneind
	replace tenure=0 if tenure==. & oneind!=. & oneind!=0 & oneind!=999 & oneind!=.m & oneind!=.s & L2.oneind!=. & L2.oneind!=0 & L2.oneind!=999 & L2.oneind!=.m & L2.oneind!=.s & oneind!=L2.oneind & year>1997


** filling in

replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0
	*this piece is only defined for 1988-1993*
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999
replace tenure=L.tenure+1 if tenure==. & L.tenure!=. & tenurez>=98 & tenurez<=9999

forvalues z=1(1)10 {
	replace tenure=F`z'.tenure-`z' if tenure==. & F`z'.tenure!=. & F`z'.tenure>=`z'
}



*this piece is only defined for 1970-1975 - stronger attributions*
replace tenure=22 if tenure==. & tenurex==6 
replace tenure=15 if tenure==. & tenurex==5
replace tenure=6 if tenure==. & tenurex==4
replace tenure=2 if tenure==. & tenurex==3

	replace tenure=F.tenure-1 if tenure==. & F.tenure!=. & F.tenure>=1
forvalues z=2(1)10 {
	replace tenure=F`z'.tenure-`z' if tenure==. & F`z'.tenure!=. & F`z'.tenure>=`z'
}


* More agressive tenure attributions when data are still missing

replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0
replace tenure=0 if tenure==. & (student==1|F.student==1)
replace tenure=0 if tenure==. & L.student==1 & annhrs<=500
replace tenure=1 if tenure==. & L.student==1 & annhrs>500
replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0

replace tenure=0 if tenure==. & L2.tenure==0 & annhrs<=500
replace tenure=1 if tenure==. & L2.tenure==0 & annhrs>500
replace tenure=0 if tenure==. & L2.student==1 & annhrs<=500
replace tenure=1 if tenure==. & L2.student==1 & annhrs>500

replace tenure=8 if tenure==. & tenurey==98

forvalues z=1(1)8 {
	replace tenure=F`z'.tenure-`z' if tenure==. & F`z'.tenure!=. & F`z'.tenure>=`z'
}

replace tenure=0 if tenure==. & L.tenure==0 & (F.tenure==0|F.tenure==1)
replace tenure=0 if tenure==. & (L.tenure==0|L2.tenure==0) & (F2.tenure==0|F2.tenure==1)
replace tenure=0 if tenure==. & L.tenure==0 & F.tenure==0


** Now filling in missing occ and ind data based on tenure

replace occ=L.occ if (occ==.|occ==.m|occ==.s|occ==0|occ==999) & L.occ!=. & L.occ!=.m & L.occ!=.s & L.occ!=0 & tenure!=. & tenure>1
replace occ=F.occ if (occ==.|occ==.m|occ==.s|occ==0|occ==999) & F.occ!=. & F.occ!=.m & F.occ!=.s & F.occ!=0 & F.tenure!=. & F.tenure>=1
replace twoind=L.twoind if (twoind==.|twoind==.m|twoind==.s|twoind==0|twoind==999) & L.twoind!=. & L.twoind!=.m & L.twoind!=.s & L.twoind!=0 & tenure!=. & tenure>1
replace twoind=F.twoind if (twoind==.|twoind==.m|twoind==.s|twoind==0|twoind==999) & F.twoind!=. & F.twoind!=.m & F.twoind!=.s & F.twoind!=0 & F.tenure!=. & F.tenure>=1
replace oneind=L.oneind if (oneind==.|oneind==.m|oneind==.s|oneind==0|oneind==999) & L.oneind!=. & L.oneind!=.m & L.oneind!=.s & L.oneind!=0 & tenure!=. & tenure>1
replace oneind=F.oneind if (oneind==.|oneind==.m|oneind==.s|oneind==0|oneind==999) & F.oneind!=. & F.oneind!=.m & F.oneind!=.s & F.oneind!=0 & F.tenure!=. & F.tenure>=1


forvalues z=2(1)43 {

	replace occ=L`z'.occ if (occ==.|occ==.m|occ==.s|occ==0|occ==999) & L`z'.occ!=. & L`z'.occ!=.m & L`z'.occ!=.s & L`z'.occ!=0 & tenure!=. & tenure>`z'

	replace occ=F`z'.occ if (occ==.|occ==.m|occ==.s|occ==0|occ==999) & F`z'.occ!=. & F`z'.occ!=.m & F`z'.occ!=.s & F`z'.occ!=0 & F`z'.tenure!=. & F`z'.tenure>=`z'

	replace twoind=L`z'.twoind if (twoind==.|twoind==.m|twoind==.s|twoind==0|twoind==999) & L`z'.twoind!=. & L`z'.twoind!=.m & L`z'.twoind!=.s & L`z'.twoind!=0 & tenure!=. & tenure>`z'

	replace twoind=F`z'.twoind if (twoind==.|twoind==.m|twoind==.s|twoind==0|twoind==999) & F`z'.twoind!=. & F`z'.twoind!=.m & F`z'.twoind!=.s & F`z'.twoind!=0 & F`z'.tenure!=. & F`z'.tenure>=`z'

	replace oneind=L`z'.oneind if (oneind==.|oneind==.m|oneind==.s|oneind==0|oneind==999) & L`z'.oneind!=. & L`z'.oneind!=.m & L`z'.oneind!=.s & L`z'.oneind!=0 & tenure!=. & tenure>`z'

	replace oneind=F`z'.oneind if (oneind==.|oneind==.m|oneind==.s|oneind==0|oneind==999) & F`z'.oneind!=. & F`z'.oneind!=.m & F`z'.oneind!=.s & F`z'.oneind!=0 & F`z'.tenure!=. & F`z'.tenure>=`z'

}


** For those who still have unknown tenure

gen tenmiss=0
	replace tenmiss=1 if tenure==.
	label variable tenmiss "=1 if tenure cannot be inferred"
gen tenmiss26=0
	replace tenmiss26=1 if tenmiss==1 & currentage<=26
	label variable tenmiss26 "=1 if tenure cannot be inferred, age<=26"

replace tenure=0 if tenure==.

gen lowtenure=0
	replace lowtenure=1 if tenure>=0 & tenure<=1
	label variable lowtenure "=1 if new on job (tenure<=1)"

drop tenurew tenurex tenurey tenurez





