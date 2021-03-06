
set hive.vectorized.execution.enabled=true;
set hive.fetch.task.conversion=minimal;

drop table if exists vector_date_1;
create table vector_date_1 (dt1 date, dt2 date) stored as orc;

insert into table vector_date_1
  select null, null from src limit 1;
insert into table vector_date_1
  select date '1999-12-31', date '2000-01-01' from src limit 1;
insert into table vector_date_1
  select date '2001-01-01', date '2001-06-01' from src limit 1;

-- column-to-column comparison in select clause
explain
select
  dt1, dt2,
  -- should be all true
  dt1 = dt1,
  dt1 != dt2,
  dt1 <= dt1,
  dt1 <= dt2,
  dt1 < dt2,
  dt2 >= dt2,
  dt2 >= dt1,
  dt2 > dt1
from vector_date_1 order by dt1;

select
  dt1, dt2,
  -- should be all true
  dt1 = dt1,
  dt1 != dt2,
  dt1 <= dt1,
  dt1 <= dt2,
  dt1 < dt2,
  dt2 >= dt2,
  dt2 >= dt1,
  dt2 > dt1
from vector_date_1 order by dt1;

explain
select
  dt1, dt2,
  -- should be all false
  dt1 != dt1,
  dt1 = dt2,
  dt1 < dt1,
  dt1 >= dt2,
  dt1 > dt2,
  dt2 > dt2,
  dt2 <= dt1,
  dt2 < dt1
from vector_date_1 order by dt1;

select
  dt1, dt2,
  -- should be all false
  dt1 != dt1,
  dt1 = dt2,
  dt1 < dt1,
  dt1 >= dt2,
  dt1 > dt2,
  dt2 > dt2,
  dt2 <= dt1,
  dt2 < dt1
from vector_date_1 order by dt1;

-- column-to-literal/literal-to-column comparison in select clause
explain
select
  dt1,
  -- should be all true
  dt1 != date '1970-01-01',
  dt1 >= date '1970-01-01',
  dt1 > date '1970-01-01',
  dt1 <= date '2100-01-01',
  dt1 < date '2100-01-01',
  date '1970-01-01' != dt1,
  date '1970-01-01' <= dt1,
  date '1970-01-01' < dt1
from vector_date_1 order by dt1;

select
  dt1,
  -- should be all true
  dt1 != date '1970-01-01',
  dt1 >= date '1970-01-01',
  dt1 > date '1970-01-01',
  dt1 <= date '2100-01-01',
  dt1 < date '2100-01-01',
  date '1970-01-01' != dt1,
  date '1970-01-01' <= dt1,
  date '1970-01-01' < dt1
from vector_date_1 order by dt1;

explain
select
  dt1,
  -- should all be false
  dt1 = date '1970-01-01',
  dt1 <= date '1970-01-01',
  dt1 < date '1970-01-01',
  dt1 >= date '2100-01-01',
  dt1 > date '2100-01-01',
  date '1970-01-01' = dt1,
  date '1970-01-01' >= dt1,
  date '1970-01-01' > dt1
from vector_date_1 order by dt1;

select
  dt1,
  -- should all be false
  dt1 = date '1970-01-01',
  dt1 <= date '1970-01-01',
  dt1 < date '1970-01-01',
  dt1 >= date '2100-01-01',
  dt1 > date '2100-01-01',
  date '1970-01-01' = dt1,
  date '1970-01-01' >= dt1,
  date '1970-01-01' > dt1
from vector_date_1 order by dt1;


-- column-to-column comparisons in predicate
-- all rows with non-null dt1 should be returned
explain
select
  dt1, dt2
from vector_date_1
where
  dt1 = dt1
  and dt1 != dt2
  and dt1 < dt2
  and dt1 <= dt2
  and dt2 > dt1
  and dt2 >= dt1
order by dt1;

select
  dt1, dt2
from vector_date_1
where
  dt1 = dt1
  and dt1 != dt2
  and dt1 < dt2
  and dt1 <= dt2
  and dt2 > dt1
  and dt2 >= dt1
order by dt1;

-- column-to-literal/literal-to-column comparison in predicate
-- only a single row should be returned
explain
select
  dt1, dt2
from vector_date_1
where
  dt1 = date '2001-01-01'
  and date '2001-01-01' = dt1
  and dt1 != date '1970-01-01'
  and date '1970-01-01' != dt1
  and dt1 > date '1970-01-01'
  and dt1 >= date '1970-01-01'
  and date '1970-01-01' < dt1
  and date '1970-01-01' <= dt1
order by dt1;

select
  dt1, dt2
from vector_date_1
where
  dt1 = date '2001-01-01'
  and date '2001-01-01' = dt1
  and dt1 != date '1970-01-01'
  and date '1970-01-01' != dt1
  and dt1 > date '1970-01-01'
  and dt1 >= date '1970-01-01'
  and date '1970-01-01' < dt1
  and date '1970-01-01' <= dt1
order by dt1;

drop table vector_date_1;
