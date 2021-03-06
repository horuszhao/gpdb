-- Tests to update AO tables with indexes.
CREATE TABLE sto_alt_uao3_idx(
  text_col text,
  bigint_col bigint,
  char_vary_col character varying(30),
  numeric_col numeric
  ) with(appendonly=true) DISTRIBUTED by (text_col);
Create index sto_alt_uao3_idx_idx on sto_alt_uao3_idx(bigint_col);
insert into sto_alt_uao3_idx values ('1_zero', 1, '1_zero', 1);
insert into sto_alt_uao3_idx select 'abc_'||i, i, 'pqr'||i, i
 from generate_series(1,100)i;
select count(*) AS visible_only from sto_alt_uao3_idx;
update sto_alt_uao3_idx set numeric_col = 100 where text_col = '1_zero';
select count(*) AS visible_only from sto_alt_uao3_idx;
set gp_select_invisible = true;
select count(*) AS all_tuples from sto_alt_uao3_idx;
set gp_select_invisible = false;
-- Update indexed column
update sto_alt_uao3_idx set bigint_col = numeric_col % 11;
select * from sto_alt_uao3_idx where bigint_col = 11;
set gp_select_invisible = true;
select * from sto_alt_uao3_idx where bigint_col = 11;
set gp_select_invisible = false;

-- Alter table cluster on indexname
Alter table sto_alt_uao3_idx cluster on sto_alt_uao3_idx_idx;
select * from sto_alt_uao3_idx where bigint_col = 7 order by numeric_col;
update sto_alt_uao3_idx set numeric_col = 111 where text_col = '1_zero';
select * from sto_alt_uao3_idx where text_col = '1_zero';
delete from sto_alt_uao3_idx where bigint_col = 7;
select * from sto_alt_uao3_idx where bigint_col = 7;
set gp_select_invisible = true;
select count(*) > 200 AS passed from sto_alt_uao3_idx;
set gp_select_invisible = false;
-- Verify that cluster is not allowed
CLUSTER sto_alt_uao3_idx using sto_alt_uao3_idx_idx;
-- Verify that unique index is not allowed
CREATE UNIQUE INDEX uni_index ON sto_alt_uao3_idx (text_col);
