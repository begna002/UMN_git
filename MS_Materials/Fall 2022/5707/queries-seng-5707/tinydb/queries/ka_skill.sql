drop table kermit_achievement;
drop table s_code_of_k_achieved_skill;

SET SERVEROUTPUT ON
DECLARE
BEGIN
       ops.go(
               ops.filter_ra('achievement','c_id=''7''','kermit_achievement')
       );
       ops.go(
               -- table names are limited to 30 characters :(
               ops.reduce_ra('kermit_achievement','s_code','s_code_of_k_achieved_skill')
       );

END;
/

select * from s_code_of_k_achieved_skill;