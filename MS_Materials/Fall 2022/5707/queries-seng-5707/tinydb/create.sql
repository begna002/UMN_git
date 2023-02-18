--------------------------------------------------------------------
-- define tables for creature/skill database
--
-- Created - Paul J. Wagner, for Postgres95, 4/1/97, based on
--                           tables created by John Carlis for
--                           the Queries book     
-- Modified - Paul J. Wagner, for PostgreSQL, 2/25/98
-- Modified - Paul J. Wagner, for Oracle 7, 11/05/98
-- Modified - Paul J. Wagner, for Personal Oracle 8, 6/13/2000
-- Modified - Paul J. Wagner, for (Personal) Oracle 11, 2/1/2016
-- Modified - Paul J. Wagner, Oracle 11, added vary/range back in, 6/30/2016
--------------------------------------------------------------------

-- creature table
create table Creature
  (C_id             smallint    ,
   C_name           varchar(15) ,
   C_type           varchar(10) ,
   reside_t_id      varchar(2)  ,
   primary key (C_id)
  );

-- skill table
create table Skill
  (S_code       char            ,
   S_desc       varchar(15)     ,
   S_weight     number          ,
   origin_t_id  varchar(2)      ,
   primary key (S_code)
  );

-- achievement table
create table Achievement
  (C_id         smallint        ,
   S_code       char            ,
   score        smallint        ,
   test_t_id    varchar(2)      ,
   primary key (C_id, S_code)
  );

-- achievement (basic) table
create table Achievement_Basic
  (C_id         smallint        ,
   S_code       char            ,
   primary key (C_id, S_code)
  );

-- aspiration table
create table Aspiration
  (C_id         smallint        ,
   S_code       char            ,
   score        smallint        ,
   test_t_id    varchar(2)      ,
   primary key (C_id, S_code)
  );

-- town table
create table Town 
  (T_id        varchar(2)       ,
   T_name      varchar(15)      ,
   Mayor_C_id  smallint         ,
   Biggest_Rival_T_id varchar(2),
   primary key (T_id)
  );

-- job table
create table Job
  (J_code      varchar(15)      ,
   J_desc      varchar(25)      ,
   primary key (J_code)
  );

-- job vary table, varying DEMONS-ZA
create table JobVD
  (J_code      varchar(15)      ,
   J_desc      varchar(25)      ,
   Vary        varchar(8)       ,
   primary key (J_code)
  );

-- job vary table, varying counts expressions
create table JobVC
  (J_code      varchar(15)      ,
   J_desc      varchar(25)      ,
   Vary        varchar(50)      ,
   primary key (J_code)
  );

-- job vary table, varying range expressions
create table JobVR
  (J_code      varchar(15)      ,
   J_desc      varchar(25)      ,
   Range_Test  varchar(100)     ,
   primary key (J_code)
  );

-- job vary table, varying DEMONS-ZA and range expressions
create table JobVDVR
  (J_code      varchar(15)      ,
   J_desc      varchar(25)      ,
   Vary        varchar(8)       ,
   Range_Test  varchar(100)     ,
   primary key (J_code)
  );

-- job vary table, varying counts and range expressions
create table JobVCVR
  (J_code      varchar(15)      ,
   J_desc      varchar(25)      ,
   Vary        varchar(50)      ,
   Range_Test  varchar(100)     ,
   primary key (J_code)
  );
   
-- job_skill table
create table Job_Skill
  (J_code      varchar(15)      ,
   S_code      char             ,
   primary key (J_code, S_code)
  );

-- job_skill_range table
create table Job_Skill_Range
  (J_code      varchar(15)      ,
   S_code_lo   char             ,
   S_code_hi   char             ,
   primary key (J_code, S_code_lo, S_code_hi)
  );

-- job_skill_score table
create table Job_Skill_Score
  (J_code      varchar(15)      ,
   S_code2     char             ,
   Score2      char             ,
   primary key (J_code, S_code2)
  );

-- job_skill_score_range table
create table Job_Skill_Score_Range
  (J_code      varchar(15)      ,
   S_code2     char             ,
   Score_lo    char             ,
   Score_hi    char             ,
   primary key (J_code, S_code2)
  );

-- job_skill_range vary table
create table Job_Skill_RangeV
  (J_code      varchar(15)      ,
   S_code_lo   char             ,
   S_code_hi   char             ,
   Range_Test  varchar(100)     ,
   primary key (J_code, S_code_lo, S_code_hi)
  );

-- survivor table
create table Survivor
  (S_Code      char             ,
   primary key (S_code)
  );
