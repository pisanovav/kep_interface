# Interface to KEP economic statistics in R

KEP is a Rosstat database of short-term economic indicators on Russian economic conditions.

```get.zoo.kep()``` in [kep_interface.r](kep_interface.r) is an access function to get ```zoo```-type time series by name from KEP. Can also write to local .csv file by ```write.csv.kep()```.

Example:

```R
cpi = get.zoo.kep('CPI_rog','m')
write.csv.kep('CPI_rog','m')
```

For more information on the database see:
 - <https://github.com/epogrebnyak/rosstat-kep-data> - root folder
 - <https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/varnames.md> - available time series codes
