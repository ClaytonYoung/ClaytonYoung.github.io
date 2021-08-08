---
layout: page
title: MTA project
---



```python
import pandas as pd
from datetime import date, datetime
import matplotlib.pyplot as plt
import seaborn as sns
```

```python
#http://web.mta.info/developers/turnstile.html
link = "http://web.mta.info/developers/data/nyct/turnstile/turnstile_{}.txt"

dates=pd.Series(['2021-07-31', '2021-07-24', 
       '2021-07-17', '2021-07-10',
       '2021-07-03', '2021-06-26', 
       '2021-06-19', '2021-06-12', 
       '2021-06-05', '2021-05-29', 
       '2021-05-22', '2021-05-15', 
       '2021-05-08', '2021-05-01', 
       '2021-04-24', '2021-04-17', 
       '2021-04-10', '2021-04-03', 
       '2021-03-27', '2021-03-20', 
       '2021-03-13', '2021-03-06', 
       '2021-02-27', '2021-02-20', 
       '2021-02-13', '2021-02-06', 
       '2021-01-30', '2021-01-23', 
       '2021-01-16', '2021-01-09', 
       '2021-01-02'])

dates = pd.to_datetime(dates).dt.strftime('%y%m%d')
dates
```




    0     210731
    1     210724
    2     210717
    3     210710
    4     210703
    5     210626
    6     210619
    7     210612
    8     210605
    9     210529
    10    210522
    11    210515
    12    210508
    13    210501
    14    210424
    15    210417
    16    210410
    17    210403
    18    210327
    19    210320
    20    210313
    21    210306
    22    210227
    23    210220
    24    210213
    25    210206
    26    210130
    27    210123
    28    210116
    29    210109
    30    210102
    dtype: object



```python
#saving output of fxn to df
def rac(a_list, url):
    data = pd.DataFrame()
    for date in a_list:
        data = pd.concat([pd.read_csv(url.format(date)), data])
    return data

turnstiles_df = rac(dates, link)
```

```python
TURNSTILES_DF = turnstiles_df.copy()
```

```python
turnstiles_df.shape
```




    (6488049, 11)



```python
turnstiles_df.columns = [column.strip() for column in turnstiles_df.columns]
turnstiles_df.columns
```




    Index(['C/A', 'UNIT', 'SCP', 'STATION', 'LINENAME', 'DIVISION', 'DATE', 'TIME',
           'DESC', 'ENTRIES', 'EXITS'],
          dtype='object')



```python
# Take the date and time fields into a single datetime column
turnstiles_df["DATE_TIME"] = pd.to_datetime(turnstiles_df.DATE + " " + turnstiles_df.TIME, 
                                            format="%m/%d/%Y %H:%M:%S")
```

```python
turnstiles_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>LINENAME</th>
      <th>DIVISION</th>
      <th>DATE</th>
      <th>TIME</th>
      <th>DESC</th>
      <th>ENTRIES</th>
      <th>EXITS</th>
      <th>DATE_TIME</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>209462</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>R</td>
      <td>RIT</td>
      <td>07/30/2021</td>
      <td>21:00:00</td>
      <td>REGULAR</td>
      <td>5554</td>
      <td>591</td>
      <td>2021-07-30 21:00:00</td>
    </tr>
    <tr>
      <th>209461</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>R</td>
      <td>RIT</td>
      <td>07/30/2021</td>
      <td>17:00:00</td>
      <td>REGULAR</td>
      <td>5554</td>
      <td>590</td>
      <td>2021-07-30 17:00:00</td>
    </tr>
    <tr>
      <th>209460</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>R</td>
      <td>RIT</td>
      <td>07/30/2021</td>
      <td>13:00:00</td>
      <td>REGULAR</td>
      <td>5554</td>
      <td>589</td>
      <td>2021-07-30 13:00:00</td>
    </tr>
    <tr>
      <th>209459</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>R</td>
      <td>RIT</td>
      <td>07/30/2021</td>
      <td>09:00:00</td>
      <td>REGULAR</td>
      <td>5554</td>
      <td>589</td>
      <td>2021-07-30 09:00:00</td>
    </tr>
    <tr>
      <th>209458</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>R</td>
      <td>RIT</td>
      <td>07/30/2021</td>
      <td>05:00:00</td>
      <td>REGULAR</td>
      <td>5554</td>
      <td>589</td>
      <td>2021-07-30 05:00:00</td>
    </tr>
  </tbody>
</table>
</div>



### Data cleaning


```python
# Sanity Check to verify that "C/A", "UNIT", "SCP", "STATION", "DATE_TIME" is unique
(turnstiles_df
 .groupby(["C/A", "UNIT", "SCP", "STATION", "DATE_TIME"])
 .EXITS.count()
 .reset_index()
 .sort_values("EXITS", ascending=False)).head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>551632</th>
      <td>B024</td>
      <td>R211</td>
      <td>00-05-00</td>
      <td>KINGS HWY</td>
      <td>2021-05-04 00:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5835506</th>
      <td>R514</td>
      <td>R094</td>
      <td>00-05-00</td>
      <td>ASTORIA BLVD</td>
      <td>2021-07-22 00:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4366527</th>
      <td>R145</td>
      <td>R032</td>
      <td>00-00-02</td>
      <td>TIMES SQ-42 ST</td>
      <td>2021-02-03 03:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5835510</th>
      <td>R514</td>
      <td>R094</td>
      <td>00-05-00</td>
      <td>ASTORIA BLVD</td>
      <td>2021-07-22 08:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5835511</th>
      <td>R514</td>
      <td>R094</td>
      <td>00-05-00</td>
      <td>ASTORIA BLVD</td>
      <td>2021-07-22 12:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4497705</th>
      <td>R162</td>
      <td>R166</td>
      <td>00-00-00</td>
      <td>79 ST</td>
      <td>2020-12-30 00:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4366526</th>
      <td>R145</td>
      <td>R032</td>
      <td>00-00-02</td>
      <td>TIMES SQ-42 ST</td>
      <td>2021-02-02 23:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4497707</th>
      <td>R162</td>
      <td>R166</td>
      <td>00-00-00</td>
      <td>79 ST</td>
      <td>2020-12-30 08:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4497708</th>
      <td>R162</td>
      <td>R166</td>
      <td>00-00-00</td>
      <td>79 ST</td>
      <td>2020-12-30 12:00:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4497709</th>
      <td>R162</td>
      <td>R166</td>
      <td>00-00-00</td>
      <td>79 ST</td>
      <td>2020-12-30 16:00:00</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>



Decent amount of duplicates... why?

```python
mask = ((turnstiles_df["C/A"] == "B024") & 
(turnstiles_df["UNIT"] == "R211") & 
(turnstiles_df["SCP"] == "00-05-00") & 
(turnstiles_df["STATION"] == "KINGS HWY") &
(turnstiles_df['DATE_TIME'] == '2021-05-04 00:00:00'))

turnstiles_df[mask].head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>LINENAME</th>
      <th>DIVISION</th>
      <th>DATE</th>
      <th>TIME</th>
      <th>DESC</th>
      <th>ENTRIES</th>
      <th>EXITS</th>
      <th>DATE_TIME</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>17739</th>
      <td>B024</td>
      <td>R211</td>
      <td>00-05-00</td>
      <td>KINGS HWY</td>
      <td>BQ</td>
      <td>BMT</td>
      <td>05/04/2021</td>
      <td>00:00:00</td>
      <td>REGULAR</td>
      <td>262152</td>
      <td>0</td>
      <td>2021-05-04</td>
    </tr>
    <tr>
      <th>17740</th>
      <td>B024</td>
      <td>R211</td>
      <td>00-05-00</td>
      <td>KINGS HWY</td>
      <td>BQ</td>
      <td>BMT</td>
      <td>05/04/2021</td>
      <td>00:00:00</td>
      <td>RECOVR AUD</td>
      <td>16</td>
      <td>0</td>
      <td>2021-05-04</td>
    </tr>
  </tbody>
</table>
</div>



Recovery files are likely the issue. What percentage of the data are the recovery files?

```python
turnstiles_df.DESC.value_counts()['REGULAR']/turnstiles_df.DESC.value_counts().sum()

```




    0.99586270079033



* 99% of data is regular. Remove the recovery entries and proceed. 

```python
turnstiles_df = turnstiles_df[(turnstiles_df['DESC']=='REGULAR')]

# verify that filter worked and we removed the RECOVR AUD entries
(turnstiles_df
 .groupby(["C/A", "UNIT", "LINENAME", "SCP", "STATION", "DATE_TIME"])
 .EXITS.count()
 .reset_index()
 .sort_values("EXITS", ascending=False)).head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>LINENAME</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-00-00</td>
      <td>59 ST</td>
      <td>2020-12-26 03:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307479</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-17 17:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307477</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-17 09:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307476</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-17 05:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307475</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-17 01:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307474</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-16 21:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307473</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-16 17:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307472</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-16 13:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307471</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-16 09:00:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4307470</th>
      <td>R138</td>
      <td>R293</td>
      <td>123ACE</td>
      <td>00-03-04</td>
      <td>34 ST-PENN STA</td>
      <td>2021-01-16 05:00:00</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



```python
# Get rid of other duplicate entry
turnstiles_df.sort_values(["C/A", "UNIT", "LINENAME", "SCP", "STATION", "DATE_TIME"], 
                          inplace=True, ascending=False)
turnstiles_df.drop_duplicates(subset=["C/A", "UNIT", "LINENAME", "SCP", "STATION", "DATE_TIME"], inplace=True)
```

```python
#check shape out now after filtering 
turnstiles_df.shape
```




    (6461206, 12)



* No more duplicate Entries

## Deal with odd counter behaviour (repeats/turnover)

```python
turnstiles_daily_hourly = (turnstiles_df
                        .groupby(["C/A", "UNIT", "LINENAME", "SCP", "STATION", "DATE_TIME"],as_index=False)
                        .EXITS.first())
```

```python
turnstiles_daily_hourly[["PREV_DATE_TIME", "PREV_EXITS"]] = (turnstiles_daily_hourly
                                                       .groupby(["C/A", "UNIT", "LINENAME", "SCP", "STATION"])["DATE_TIME", "EXITS"]
                                                       .apply(lambda grp: grp.shift(1)))
```

    <ipython-input-60-c05671fe7afe>:1: FutureWarning: Indexing with multiple keys (implicitly converted to a tuple of keys) will be deprecated, use a list instead.
      turnstiles_daily_hourly[["PREV_DATE_TIME", "PREV_EXITS"]] = (turnstiles_daily_hourly


```python
turnstiles_daily_hourly
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>LINENAME</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>EXITS</th>
      <th>PREV_DATE_TIME</th>
      <th>PREV_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-00-00</td>
      <td>59 ST</td>
      <td>2020-12-26 03:00:00</td>
      <td>2557569</td>
      <td>NaT</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-00-00</td>
      <td>59 ST</td>
      <td>2020-12-26 07:00:00</td>
      <td>2557581</td>
      <td>2020-12-26 03:00:00</td>
      <td>2557569.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-00-00</td>
      <td>59 ST</td>
      <td>2020-12-26 11:00:00</td>
      <td>2557636</td>
      <td>2020-12-26 07:00:00</td>
      <td>2557581.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-00-00</td>
      <td>59 ST</td>
      <td>2020-12-26 15:00:00</td>
      <td>2557667</td>
      <td>2020-12-26 11:00:00</td>
      <td>2557636.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-00-00</td>
      <td>59 ST</td>
      <td>2020-12-26 19:00:00</td>
      <td>2557689</td>
      <td>2020-12-26 15:00:00</td>
      <td>2557667.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>6461201</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>R</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>2021-07-30 05:00:00</td>
      <td>589</td>
      <td>2021-07-30 01:00:00</td>
      <td>589.0</td>
    </tr>
    <tr>
      <th>6461202</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>R</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>2021-07-30 09:00:00</td>
      <td>589</td>
      <td>2021-07-30 05:00:00</td>
      <td>589.0</td>
    </tr>
    <tr>
      <th>6461203</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>R</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>2021-07-30 13:00:00</td>
      <td>589</td>
      <td>2021-07-30 09:00:00</td>
      <td>589.0</td>
    </tr>
    <tr>
      <th>6461204</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>R</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>2021-07-30 17:00:00</td>
      <td>590</td>
      <td>2021-07-30 13:00:00</td>
      <td>589.0</td>
    </tr>
    <tr>
      <th>6461205</th>
      <td>TRAM2</td>
      <td>R469</td>
      <td>R</td>
      <td>00-05-01</td>
      <td>RIT-ROOSEVELT</td>
      <td>2021-07-30 21:00:00</td>
      <td>591</td>
      <td>2021-07-30 17:00:00</td>
      <td>590.0</td>
    </tr>
  </tbody>
</table>
<p>6461206 rows × 9 columns</p>
</div>



Drop rows where there isn't a previous date-we can't find how many entries there were for those days without the preceeding info. 

```python
turnstiles_daily_hourly.dropna(subset=["PREV_DATE_TIME"], axis=0, inplace=True)
```

Check out data some more-find the negative diffs. 

```python
turnstiles_daily_hourly[turnstiles_daily_hourly["EXITS"] < turnstiles_daily_hourly["PREV_EXITS"]].head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>LINENAME</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>EXITS</th>
      <th>PREV_DATE_TIME</th>
      <th>PREV_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5643</th>
      <td>A002</td>
      <td>R051</td>
      <td>NQR456W</td>
      <td>02-03-02</td>
      <td>59 ST</td>
      <td>2021-03-22 16:00:00</td>
      <td>8</td>
      <td>2021-03-22 12:00:00</td>
      <td>8869858.0</td>
    </tr>
    <tr>
      <th>27320</th>
      <td>A007</td>
      <td>R079</td>
      <td>NQRW</td>
      <td>01-05-01</td>
      <td>5 AV/59 ST</td>
      <td>2021-02-08 13:00:00</td>
      <td>7</td>
      <td>2021-02-06 01:00:00</td>
      <td>26.0</td>
    </tr>
    <tr>
      <th>50513</th>
      <td>A011</td>
      <td>R080</td>
      <td>NQRW</td>
      <td>01-03-00</td>
      <td>57 ST-7 AV</td>
      <td>2020-12-26 07:00:00</td>
      <td>489704004</td>
      <td>2020-12-26 03:00:00</td>
      <td>489704028.0</td>
    </tr>
    <tr>
      <th>50514</th>
      <td>A011</td>
      <td>R080</td>
      <td>NQRW</td>
      <td>01-03-00</td>
      <td>57 ST-7 AV</td>
      <td>2020-12-26 11:00:00</td>
      <td>489703879</td>
      <td>2020-12-26 07:00:00</td>
      <td>489704004.0</td>
    </tr>
    <tr>
      <th>50515</th>
      <td>A011</td>
      <td>R080</td>
      <td>NQRW</td>
      <td>01-03-00</td>
      <td>57 ST-7 AV</td>
      <td>2020-12-26 15:00:00</td>
      <td>489703733</td>
      <td>2020-12-26 11:00:00</td>
      <td>489703879.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
(turnstiles_daily_hourly[turnstiles_daily_hourly["EXITS"] < turnstiles_daily_hourly["PREV_EXITS"]]
    .groupby(["C/A", "UNIT", "LINENAME", "SCP", "STATION"])
    .size().sort_values(ascending=False))
```




    C/A    UNIT  LINENAME  SCP       STATION        
    R523   R147  7         00-00-04  61 ST WOODSIDE     1306
    R622   R123  2345S     00-00-00  FRANKLIN AV        1300
    N205   R195  BD4       02-00-00  161/YANKEE STAD    1300
    A011   R080  NQRW      01-03-00  57 ST-7 AV         1299
    R127   R105  123FLM    00-00-00  14 ST              1297
                                                        ... 
    N329   R201  MR        00-03-00  WOODHAVEN BLVD        1
    N325A  R218  MR        00-00-00  ELMHURST AV           1
    N324   R018  EFMR7     00-03-04  JKSN HT-ROOSVLT       1
                           00-03-03  JKSN HT-ROOSVLT       1
    PTH04  R551  1         00-04-02  GROVE STREET          1
    Length: 424, dtype: int64



```python
turnstiles_daily_hourly[(turnstiles_daily_hourly['C/A']=='R523')&
                        (turnstiles_daily_hourly['UNIT']=='R147')&
                        (turnstiles_daily_hourly['LINENAME']== '7')&
                        (turnstiles_daily_hourly['SCP']=='00-00-04')&
                        (turnstiles_daily_hourly['STATION']=='61 ST WOODSIDE')] 
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>UNIT</th>
      <th>LINENAME</th>
      <th>SCP</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>EXITS</th>
      <th>PREV_DATE_TIME</th>
      <th>PREV_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5877151</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2020-12-26 04:00:00</td>
      <td>2123073333</td>
      <td>2020-12-26 00:00:00</td>
      <td>2.123073e+09</td>
    </tr>
    <tr>
      <th>5877152</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2020-12-26 08:00:00</td>
      <td>2123073311</td>
      <td>2020-12-26 04:00:00</td>
      <td>2.123073e+09</td>
    </tr>
    <tr>
      <th>5877153</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2020-12-26 12:00:00</td>
      <td>2123073239</td>
      <td>2020-12-26 08:00:00</td>
      <td>2.123073e+09</td>
    </tr>
    <tr>
      <th>5877154</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2020-12-26 16:00:00</td>
      <td>2123073107</td>
      <td>2020-12-26 12:00:00</td>
      <td>2.123073e+09</td>
    </tr>
    <tr>
      <th>5877155</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2020-12-26 20:00:00</td>
      <td>2123072967</td>
      <td>2020-12-26 16:00:00</td>
      <td>2.123073e+09</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>5878464</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2021-07-30 05:00:00</td>
      <td>2122797142</td>
      <td>2021-07-30 01:00:00</td>
      <td>2.122797e+09</td>
    </tr>
    <tr>
      <th>5878465</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2021-07-30 09:00:00</td>
      <td>2122796966</td>
      <td>2021-07-30 05:00:00</td>
      <td>2.122797e+09</td>
    </tr>
    <tr>
      <th>5878466</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2021-07-30 13:00:00</td>
      <td>2122796771</td>
      <td>2021-07-30 09:00:00</td>
      <td>2.122797e+09</td>
    </tr>
    <tr>
      <th>5878467</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2021-07-30 17:00:00</td>
      <td>2122796301</td>
      <td>2021-07-30 13:00:00</td>
      <td>2.122797e+09</td>
    </tr>
    <tr>
      <th>5878468</th>
      <td>R523</td>
      <td>R147</td>
      <td>7</td>
      <td>00-00-04</td>
      <td>61 ST WOODSIDE</td>
      <td>2021-07-30 21:00:00</td>
      <td>2122795662</td>
      <td>2021-07-30 17:00:00</td>
      <td>2.122796e+09</td>
    </tr>
  </tbody>
</table>
<p>1318 rows × 9 columns</p>
</div>



Using counter max at 500K because looking at 4-hour basis

```python
def get_daily_hourly_counts(row, max_counter):
    counter = row["EXITS"] - row["PREV_EXITS"]
    if counter < 0:
        # Maybe counter is reversed?
        counter = -counter
    if counter > max_counter:
        # Maybe counter was reset to 0? 
        #print(row["EXITS"], row["PREV_EXITS"])
        counter = min(row["EXITS"], row["PREV_EXITS"])
    if counter > max_counter:
        # Check it again to make sure we're not still giving a counter that's too big
        return 0
    return counter


# If counter is > 1Million, then the counter might have been reset.  
# Just set it to zero as different counters have different cycle limits
# It'd probably be a good idea to use a number even significantly smaller than 1 million as the limit!
turnstiles_daily_hourly["HOURLY_EXITS"] = turnstiles_daily_hourly.apply(get_daily_hourly_counts, axis=1, max_counter=500000)
```

```python
turnstiles_daily_hourly.sort_values('HOURLY_EXITS', ascending = False)
turnstiles_daily_hourly['HOURLY_EXITS'].max()
```




    995307.0



Average weekday ridership for the past 5 years is roughyl 5.5 million. We can assume that our filter and max counter is working correctly but may be too stringent. Note that the pandemic hit New York hard and people relocated during this time. 

```python
turnstiles_daily_hourly.sort_values('HOURLY_EXITS', ascending = False)
turnstiles_daily_hourly.groupby(pd.Grouper(freq='b', key = 'DATE_TIME'))['HOURLY_EXITS'].sum().sort_values(ascending=False).mean()

```




    2682441.391025641



### find hourly exits per turnstile

```python
ca_unit_station_daily_hourly = turnstiles_daily_hourly.groupby(["C/A","LINENAME", "UNIT", "STATION", "DATE_TIME"])[['HOURLY_EXITS']].sum().reset_index()
ca_unit_station_daily_hourly.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>LINENAME</th>
      <th>UNIT</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>HOURLY_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 07:00:00</td>
      <td>115.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 11:00:00</td>
      <td>601.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 15:00:00</td>
      <td>492.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 19:00:00</td>
      <td>398.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 23:00:00</td>
      <td>152.0</td>
    </tr>
  </tbody>
</table>
</div>



## Sums of hourly exits for CA/line/unit/station

```python
station_daily_hourly = turnstiles_daily_hourly.groupby(["C/A",'LINENAME', "UNIT", "STATION", "DATE_TIME"])[['HOURLY_EXITS']].sum().reset_index()
station_daily_hourly.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C/A</th>
      <th>LINENAME</th>
      <th>UNIT</th>
      <th>STATION</th>
      <th>DATE_TIME</th>
      <th>HOURLY_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 07:00:00</td>
      <td>115.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 11:00:00</td>
      <td>601.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 15:00:00</td>
      <td>492.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 19:00:00</td>
      <td>398.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>A002</td>
      <td>NQR456W</td>
      <td>R051</td>
      <td>59 ST</td>
      <td>2020-12-26 23:00:00</td>
      <td>152.0</td>
    </tr>
  </tbody>
</table>
</div>



## Sums for station and linename for hourly exits. 
Keeping linename to prevent confusion of stations with similar/same names.

```python
station_daily_hourly = turnstiles_daily_hourly.groupby(["STATION", "LINENAME", "DATE_TIME"])[['HOURLY_EXITS']].sum().reset_index()
station_daily_hourly.head()


```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>STATION</th>
      <th>LINENAME</th>
      <th>DATE_TIME</th>
      <th>HOURLY_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1 AV</td>
      <td>L</td>
      <td>2020-12-26 07:00:00</td>
      <td>229.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1 AV</td>
      <td>L</td>
      <td>2020-12-26 11:00:00</td>
      <td>874.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1 AV</td>
      <td>L</td>
      <td>2020-12-26 15:00:00</td>
      <td>1284.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1 AV</td>
      <td>L</td>
      <td>2020-12-26 19:00:00</td>
      <td>1508.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1 AV</td>
      <td>L</td>
      <td>2020-12-26 23:00:00</td>
      <td>769.0</td>
    </tr>
  </tbody>
</table>
</div>



## Hourly exits sorted by station/line for 2021

```python
station_totals_hourly = station_daily_hourly.groupby(['STATION', 'LINENAME']).sum()\
    .sort_values('HOURLY_EXITS', ascending=False)\
    .reset_index()

station_totals_hourly.head(20)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>STATION</th>
      <th>LINENAME</th>
      <th>HOURLY_EXITS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>34 ST-HERALD SQ</td>
      <td>BDFMNQRW</td>
      <td>7792433.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>GRD CNTRL-42 ST</td>
      <td>4567S</td>
      <td>7295670.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>PATH NEW WTC</td>
      <td>1</td>
      <td>7143364.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NEWARK HW BMEBE</td>
      <td>1</td>
      <td>6429367.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>34 ST-PENN STA</td>
      <td>ACE</td>
      <td>6383579.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>42 ST-PORT AUTH</td>
      <td>ACENQRS1237W</td>
      <td>5676443.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>NEWARK HM HE</td>
      <td>1</td>
      <td>5391644.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>FLUSHING-MAIN</td>
      <td>7</td>
      <td>4950858.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>FULTON ST</td>
      <td>2345ACJZ</td>
      <td>4113552.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>14 ST-UNION SQ</td>
      <td>LNQR456W</td>
      <td>4113034.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>JKSN HT-ROOSVLT</td>
      <td>EFMR7</td>
      <td>3982212.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>JOURNAL SQUARE</td>
      <td>1</td>
      <td>3927721.0</td>
    </tr>
    <tr>
      <th>12</th>
      <td>TIMES SQ-42 ST</td>
      <td>1237ACENQRSW</td>
      <td>3907268.0</td>
    </tr>
    <tr>
      <th>13</th>
      <td>23 ST</td>
      <td>1</td>
      <td>3653068.0</td>
    </tr>
    <tr>
      <th>14</th>
      <td>86 ST</td>
      <td>456</td>
      <td>3642038.0</td>
    </tr>
    <tr>
      <th>15</th>
      <td>59 ST</td>
      <td>456NQRW</td>
      <td>3556124.0</td>
    </tr>
    <tr>
      <th>16</th>
      <td>W 4 ST-WASH SQ</td>
      <td>ABCDEFM</td>
      <td>3334929.0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>47-50 STS ROCK</td>
      <td>BDFM</td>
      <td>3306434.0</td>
    </tr>
    <tr>
      <th>18</th>
      <td>59 ST COLUMBUS</td>
      <td>ABCD1</td>
      <td>3220946.0</td>
    </tr>
    <tr>
      <th>19</th>
      <td>34 ST-PENN STA</td>
      <td>123ACE</td>
      <td>3032905.0</td>
    </tr>
  </tbody>
</table>
</div>



## NEXT STEPS:
- find weekly averages
- find daily averages
- find hourly (4 hour) averages


```python
station_daily_hourly.groupby([pd.Grouper(key='STATION'),pd.Grouper(key='LINENAME'),pd.Grouper(freq='W', key='DATE_TIME')])\
                               .median().sort_values(['HOURLY_EXITS'], ascending=False).head(50)

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th></th>
      <th>HOURLY_EXITS</th>
    </tr>
    <tr>
      <th>STATION</th>
      <th>LINENAME</th>
      <th>DATE_TIME</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="8" valign="top">34 ST-HERALD SQ</th>
      <th rowspan="8" valign="top">BDFMNQRW</th>
      <th>2021-08-01</th>
      <td>8160.5</td>
    </tr>
    <tr>
      <th>2021-06-20</th>
      <td>6430.0</td>
    </tr>
    <tr>
      <th>2021-07-18</th>
      <td>6269.0</td>
    </tr>
    <tr>
      <th>2021-06-27</th>
      <td>6176.0</td>
    </tr>
    <tr>
      <th>2021-06-13</th>
      <td>6009.5</td>
    </tr>
    <tr>
      <th>2021-07-25</th>
      <td>5918.0</td>
    </tr>
    <tr>
      <th>2021-06-06</th>
      <td>5851.5</td>
    </tr>
    <tr>
      <th>2021-07-04</th>
      <td>5742.0</td>
    </tr>
    <tr>
      <th>34 ST-PENN STA</th>
      <th>ACE</th>
      <th>2021-08-01</th>
      <td>5610.5</td>
    </tr>
    <tr>
      <th>34 ST-HERALD SQ</th>
      <th>BDFMNQRW</th>
      <th>2021-07-11</th>
      <td>5500.0</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">14 ST-UNION SQ</th>
      <th rowspan="2" valign="top">LNQR456W</th>
      <th>2021-06-27</th>
      <td>5473.5</td>
    </tr>
    <tr>
      <th>2021-08-01</th>
      <td>5407.0</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">34 ST-HERALD SQ</th>
      <th rowspan="3" valign="top">BDFMNQRW</th>
      <th>2021-05-30</th>
      <td>5264.0</td>
    </tr>
    <tr>
      <th>2021-05-16</th>
      <td>5231.5</td>
    </tr>
    <tr>
      <th>2021-05-02</th>
      <td>5230.0</td>
    </tr>
    <tr>
      <th>FLUSHING-MAIN</th>
      <th>7</th>
      <th>2021-08-01</th>
      <td>5211.5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">34 ST-HERALD SQ</th>
      <th rowspan="2" valign="top">BDFMNQRW</th>
      <th>2021-05-09</th>
      <td>5167.0</td>
    </tr>
    <tr>
      <th>2021-05-23</th>
      <td>5150.0</td>
    </tr>
    <tr>
      <th>14 ST-UNION SQ</th>
      <th>LNQR456W</th>
      <th>2021-07-25</th>
      <td>5102.0</td>
    </tr>
    <tr>
      <th>FLUSHING-MAIN</th>
      <th>7</th>
      <th>2021-07-25</th>
      <td>5051.5</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">14 ST-UNION SQ</th>
      <th rowspan="4" valign="top">LNQR456W</th>
      <th>2021-07-18</th>
      <td>5027.0</td>
    </tr>
    <tr>
      <th>2021-06-20</th>
      <td>5019.0</td>
    </tr>
    <tr>
      <th>2021-06-13</th>
      <td>5002.0</td>
    </tr>
    <tr>
      <th>2021-07-04</th>
      <td>4968.5</td>
    </tr>
    <tr>
      <th>34 ST-PENN STA</th>
      <th>ACE</th>
      <th>2021-07-25</th>
      <td>4898.5</td>
    </tr>
    <tr>
      <th>34 ST-HERALD SQ</th>
      <th>BDFMNQRW</th>
      <th>2021-04-25</th>
      <td>4873.5</td>
    </tr>
    <tr>
      <th>14 ST-UNION SQ</th>
      <th>LNQR456W</th>
      <th>2021-05-23</th>
      <td>4851.0</td>
    </tr>
    <tr>
      <th>34 ST-HERALD SQ</th>
      <th>BDFMNQRW</th>
      <th>2021-04-18</th>
      <td>4850.5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">34 ST-PENN STA</th>
      <th rowspan="2" valign="top">ACE</th>
      <th>2021-07-11</th>
      <td>4793.0</td>
    </tr>
    <tr>
      <th>2021-07-04</th>
      <td>4787.5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">FLUSHING-MAIN</th>
      <th rowspan="2" valign="top">7</th>
      <th>2021-07-18</th>
      <td>4759.0</td>
    </tr>
    <tr>
      <th>2021-06-27</th>
      <td>4692.5</td>
    </tr>
    <tr>
      <th>34 ST-PENN STA</th>
      <th>ACE</th>
      <th>2021-07-18</th>
      <td>4657.0</td>
    </tr>
    <tr>
      <th>34 ST-HERALD SQ</th>
      <th>BDFMNQRW</th>
      <th>2021-04-11</th>
      <td>4634.5</td>
    </tr>
    <tr>
      <th>14 ST-UNION SQ</th>
      <th>LNQR456W</th>
      <th>2021-07-11</th>
      <td>4586.5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">FLUSHING-MAIN</th>
      <th rowspan="2" valign="top">7</th>
      <th>2021-06-20</th>
      <td>4523.0</td>
    </tr>
    <tr>
      <th>2021-07-04</th>
      <td>4481.0</td>
    </tr>
    <tr>
      <th>14 ST-UNION SQ</th>
      <th>LNQR456W</th>
      <th>2021-06-06</th>
      <td>4476.0</td>
    </tr>
    <tr>
      <th>34 ST-HERALD SQ</th>
      <th>BDFMNQRW</th>
      <th>2021-04-04</th>
      <td>4435.0</td>
    </tr>
    <tr>
      <th>14 ST-UNION SQ</th>
      <th>LNQR456W</th>
      <th>2021-05-16</th>
      <td>4383.0</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">34 ST-PENN STA</th>
      <th rowspan="2" valign="top">ACE</th>
      <th>2021-06-20</th>
      <td>4369.5</td>
    </tr>
    <tr>
      <th>2021-05-30</th>
      <td>4360.0</td>
    </tr>
    <tr>
      <th>14 ST-UNION SQ</th>
      <th>LNQR456W</th>
      <th>2021-05-30</th>
      <td>4342.5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">34 ST-HERALD SQ</th>
      <th rowspan="2" valign="top">BDFMNQRW</th>
      <th>2021-03-14</th>
      <td>4312.0</td>
    </tr>
    <tr>
      <th>2021-03-21</th>
      <td>4241.0</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">FLUSHING-MAIN</th>
      <th rowspan="3" valign="top">7</th>
      <th>2021-07-11</th>
      <td>4231.0</td>
    </tr>
    <tr>
      <th>2021-05-23</th>
      <td>4148.5</td>
    </tr>
    <tr>
      <th>2021-06-13</th>
      <td>4142.0</td>
    </tr>
    <tr>
      <th>34 ST-HERALD SQ</th>
      <th>BDFMNQRW</th>
      <th>2021-03-28</th>
      <td>4136.0</td>
    </tr>
    <tr>
      <th>GRD CNTRL-42 ST</th>
      <th>4567S</th>
      <th>2021-08-01</th>
      <td>4135.5</td>
    </tr>
  </tbody>
</table>
</div>



Plot weekly averages (median)

```python
weekly_plot_data=pd.DataFrame(station_daily_hourly.groupby([pd.Grouper(key='STATION'),pd.Grouper(freq='W', key='DATE_TIME')]).median('HOURLY_EXITS')\
                        .groupby('STATION').mean('HOURLY_EXITS').sort_values('HOURLY_EXITS', 
                                                                            ascending=False).reset_index()).head(25)
weekly_plot_data=weekly_plot_data.rename(columns={'HOURLY_EXITS':'MEDIAN_HOURLY_EXITS'})

sns.set_palette("colorblind")
sns.barplot(y=weekly_plot_data.STATION, x=weekly_plot_data['MEDIAN_HOURLY_EXITS'], data=weekly_plot_data)
sns.despine()
plt.title('Station median hourly counts for 2021')
plt.xlabel('Median hourly count for 2021')
plt.ylabel('Station')



```




    Text(0, 0.5, 'Station')




![png](https://github.com/ClaytonYoung/ClaytonYoung.github.io/blob/master/assets/MVP_Clayton_Young_files/output_45_1.png)


```python
station_daily_hourly['dayofweek']=station_daily_hourly.DATE_TIME.dt.dayofweek

station_daily_hourly[station_daily_hourly['STATION'] == '34 ST-HERALD SQ']\
                                        .groupby([pd.Grouper(freq='d', key='DATE_TIME'),'dayofweek']).median()\
                                        .sort_values(['HOURLY_EXITS'], ascending=False).head(55).value_counts('dayofweek')
#take ~top 25% 
#Monday=0
#Sunday=6
```




    dayofweek
    4    15
    3    13
    2    11
    1     9
    0     7
    dtype: int64



```python
days_of_week_data=pd.DataFrame(station_daily_hourly[station_daily_hourly['STATION'] == '34 ST-HERALD SQ']\
                                        .groupby([pd.Grouper(freq='d', key='DATE_TIME'),'dayofweek']).median()\
                                        .sort_values(['HOURLY_EXITS'], ascending=False).head(55).value_counts('dayofweek'))\
                                        .reset_index()
```

```python
days_of_week_data=days_of_week_data.rename(columns={0:'COUNTS'})
days_plot = sns.barplot(x=days_of_week_data.dayofweek, y=days_of_week_data.COUNTS, data=days_of_week_data)
days_plot.set_xticklabels(["Monday", "Tuesday","Wednesday","Thursday","Friday"])
sns.set_style('ticks')
sns.set_palette("colorblind")
sns.despine()
plt.title('Days in top 25% exits at 34 St-Herald Sq')
plt.xlabel('Day of the week')
plt.ylabel('Counts')





```




    Text(0, 0.5, 'Counts')




![png](https://github.com/ClaytonYoung/ClaytonYoung.github.io/blob/master/assets/MVP_Clayton_Young_files/output_48_1.png)


Looks like wedn,thurs, and fri are most popular days of week for this line on average

```python
common_day_times=station_daily_hourly[(station_daily_hourly['STATION'] == '34 ST-HERALD SQ') &
                     ((station_daily_hourly['dayofweek'] == 2)| 
                      (station_daily_hourly['dayofweek'] == 3) | 
                      (station_daily_hourly['dayofweek'] == 4))]\
                    .groupby([pd.Grouper(freq='h', key='DATE_TIME'),'dayofweek'])\
                    .median()\
                    .sort_values(['HOURLY_EXITS'], ascending=False)\
                    .head(55)\
                    .reset_index()\
                    
                   
```

```python
common_day_times.DATE_TIME.dt.hour.value_counts()
```




    20    30
    12    18
    16     7
    Name: DATE_TIME, dtype: int64



```python

pop_hours=pd.DataFrame(common_day_times.DATE_TIME.dt.hour.value_counts().reset_index())
pop_hours=pop_hours.rename(columns={'index':'HOUR',
                                   'DATE_TIME':'COUNT'})
pop_hours_plot = sns.barplot(x=pop_hours.HOUR, y=pop_hours.COUNT, data=pop_hours)
sns.set_palette("colorblind")
sns.despine()
plt.title('Hours of top 25% exits')
plt.xlabel('Hour')
plt.ylabel('Count')




```




    Text(0, 0.5, 'Count')



![png](https://github.com/ClaytonYoung/ClaytonYoung.github.io/blob/master/assets/MVP_Clayton_Young_files/output_52_1.png)

# Summary

So far, we've found that the 34 ST-HERALD SQ station is the most popular stop (as measured by exits) on a weekly basis, looking at the median as a safeguard to any outliers remaining in the data. We've seen that Wednesday, Thursday, and Friday are the most popular days of the week for the most popular stop, and that the four hours leading up to 8PM are where we see the most people leaving the station. 
