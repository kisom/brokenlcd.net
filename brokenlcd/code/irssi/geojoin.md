geojoin.pl
----------

**geojoin**: irssi script to get GeoIP data on users joining a channel.     
**author**: kyle isom <lt;coder@kyleisom.net>gt;     
**license**: isc / public domain - select whichever is less restrictive in your 
locale    

latest version can be pulled from 
[github](https://github.com/kisom/irssi-scripts/tree/master/geojoin)
or you can clone the entire collection of scripts using:    

`git clone git://github.com/kisom/irssi-scripts.git`


**dependencies:**
* Geo::IP
* Geo::IP::Record (can be removed if no city record support is desired)


**usage:**   
`/load /path/to/geojoin.pl`    
`/geojoin add &lt;channel list&gt;`    
wait for people to join the channel...    


**command list:**
* add &lt;channels&gt;: add channels to list to watch
* del &lt;channels&gt;: remove channels from the watch list
* status: show geojoin's status, including whether it is using country or city 
lookups, whether it is enabled, and which channels are being watched
* watchlist: show a list of space-delimited channels being watched
* use_country: use country lookups
* use_city: use city record lookups
* set_citydb &lt;path&gt;: specify path to city record database    
* disable: disable lookups (preserves watchlist)
* enable: enable lookups
* clear: clear watchlist and disables geojoin


**caveats:**
* if you want to use city records you need the 
[GeoLiteCity database](http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz)


**todo**
* add whois / info code for whois and info lookups


**screenshot**:

![screenshot: geojoin.pl](/images/screenshots/irssi-geojoin_small.png)    
[larger version](/images/screenshots/irssi-geojoin.png)   
