`profile.coffee` for finding stats on a particular user id (within a certain timerange)

`timeplot.coffee` generates a matrix of 

```
~ id0 .. idn
t0 . .. .
t1 . .. .
```

where each `.` represents the signal quality for a reading the id submitted during that time, or -1 if there is no reading

configure to your liking at the bottom of those files.