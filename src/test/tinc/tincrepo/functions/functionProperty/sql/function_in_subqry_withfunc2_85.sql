-- @description function_in_subqry_withfunc2_85.sql
-- @db_name functionproperty
-- @author tungs1
-- @modified 2013-04-03 12:00:00
-- @created 2013-04-03 12:00:00
-- @tags functionProperties 
SELECT * FROM foo, (SELECT func1_sql_setint_imm(func2_sql_int_imm(5))) r order by 1,2,3; 
