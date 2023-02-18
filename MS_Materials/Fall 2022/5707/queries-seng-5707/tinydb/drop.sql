--------------------------------------------------------------------
-- drop tables for creature/skills database
--
-- Created - Paul J. Wagner, for Postgres95, 4/1/97, based on
--                           tables created by John Carlis for
--                           the Queries book     
-- Modified - Paul J. Wagner, for PostgreSQL, 2/25/98
-- Modified - Paul J. Wagner, for Oracle 7, 11/05/98
-- Modified - Paul J. Wagner, for Personal Oracle 8, 6/13/2000
-- Modified - Paul J. Wagner, for (Personal) Oracle 11, 2/1/2016
--------------------------------------------------------------------

-- creature table
drop table Creature;

-- skill table
drop table Skill;

-- achievement table
drop table Achievement;

-- achievement (basic) table
drop table Achievement_Basic;

-- aspiration table
drop table Aspiration;

-- town table
drop table Town;

-- job table
drop table Job;

-- job vary table, varying DEMONS-ZA
drop table JobVD;

-- job vary table, varying counts expressions
drop table JobVC;

-- job vary table, varying range expressions
drop table JobVR;

-- job vary table, varying DEMONS-ZA and range
drop table JobVDVR;

-- job vary table, varying counts and range
drop table JobVCVR;

-- job_skill table
drop table Job_Skill;

-- job_skill_range table
drop table Job_Skill_Range;

-- job_skill_score table
drop table Job_Skill_Score;

-- job_skill_score_range table
drop table Job_Skill_Score_Range;

-- job_skill_range vary table, varying range expressions
drop table Job_Skill_RangeV;

-- survivor table
drop table Survivor;
