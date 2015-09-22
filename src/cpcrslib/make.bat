del *.lib

for /f %%f in ('dir /b cpc_*.rel') do sdar -rc cpcrslib.lib %%f

del *.rel


copy cpcrslib.lib d:\sdcc\lib\z80
copy cpcrslib.h d:\sdcc\include


copy cpcwyzlib.lib d:\sdcc\lib\z80
copy cpcwyzlib.h d:\sdcc\include