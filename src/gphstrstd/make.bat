for /f %%f in ('dir /b cpc_*.s') do sdasz80 -o %%f

copy *.rel "../cpcrslib/"

del *.rel




