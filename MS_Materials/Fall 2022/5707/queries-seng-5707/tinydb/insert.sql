--------------------------------------------------------------------
-- instances.sql - insert row instances for creature/skill database
--
-- Created - Paul J. Wagner, for Postgres95, 4/1/97
-- Modified- Paul J. Wagner, for PostgreSQL 6.2.1, 2/25/98
-- Modified- Paul J. Wagner, for Oracle 7, 11/5/98
-- Modified- Paul J. Wagner, added varying tables, 3/16/99
-- Modified- Paul J. Wagner, for Personal Oracle 8, added CSBasic, 6/13/2000
-- Modified - Paul J. Wagner, for (Personal) Oracle 11, 2/1/2016
--------------------------------------------------------------------

-- creature records
insert 
into Creature (C_id, C_name, C_type, reside_T_id) 
values        (1, 'Bannon', 'Person', 'p');

insert 
into Creature (C_id, C_name, C_type, reside_T_id) 
values        (2, 'Myers', 'Person', 'a');

insert 
into Creature (C_id, C_name, C_type, reside_T_id) 
values        (3, 'Neff', 'Person', 'b');

insert 
into Creature (C_id, C_name, C_type, reside_T_id) 
values        (4, 'Neff', 'Person', 'c');

insert 
into Creature (C_id, C_name, C_type, reside_T_id) 
values        (5, 'Mieska', 'Person', 'd');

insert 
into Creature (C_id, C_name, C_type, reside_T_id) 
values        (6, 'Carlis', 'Person', 'p');

insert 
into Creature (C_id, C_name, C_type, reside_T_id)
values        (7, 'Kermit', 'Frog', 'h');

insert 
into Creature (C_id, C_name, C_type, reside_T_id)
values        (8, 'Godzilla', 'Monster', 't');



-- skill records
insert
into Skill (S_code, S_desc, S_weight, origin_T_id)
values     ('A', 'Float', 0.5, 'b');

insert
into Skill (S_code, S_desc, S_weight, origin_T_id)
values     ('E', 'Swim', 0.7, 'b');

insert
into Skill (S_code, S_desc, S_weight, origin_T_id)
values     ('O', 'Sink', 0.1, 't');

insert
into Skill (S_code, S_desc, S_weight, origin_T_id)
values     ('U', 'Walk on Water', 0.9, 'em');

insert
into Skill (S_code, S_desc, S_weight, origin_T_id)
values     ('Z', 'Gargle', 0.2, 'p');


-- achievement records
insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (1, 'A', 1, 'a');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (1, 'E', 3, 'a');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (1, 'Z', 3, 'p');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (2, 'A', 3, 'b');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (3, 'A', 2, 'b');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (3, 'Z', 1, 'p');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (4, 'A', 2, 'c');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (4, 'E', 2, 'c');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (5, 'Z', 3, 'd');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (7, 'E', 1, 's');

insert
into Achievement (C_id, S_Code, score, test_T_id) 
values    (8, 'O', 1, 't');


-- Achievement_basic records
insert
into Achievement_Basic (C_id, S_Code) 
values    (1, 'A');

insert
into Achievement_Basic (C_id, S_Code) 
values    (1, 'E');

insert
into Achievement_Basic (C_id, S_Code) 
values    (1, 'Z');

insert
into Achievement_Basic (C_id, S_Code) 
values    (2, 'A');

insert
into Achievement_Basic (C_id, S_Code) 
values    (3, 'A');

insert
into Achievement_Basic (C_id, S_Code) 
values    (3, 'Z');

insert
into Achievement_Basic (C_id, S_Code) 
values    (4, 'A');

insert
into Achievement_Basic (C_id, S_Code) 
values    (4, 'E');

insert
into Achievement_Basic (C_id, S_Code) 
values    (5, 'Z');

insert
into Achievement_Basic (C_id, S_Code) 
values    (7, 'E');

insert
into Achievement_Basic (C_id, S_Code) 
values    (8, 'O');


-- aspiration records
insert
into Aspiration (C_id, S_Code, score, test_T_id)
values    (1, 'A', 1, 'a');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (1, 'E', 3, 'a');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (1, 'Z', 1, 'be');

insert
into Aspiration (C_id, S_code, score)
values    (2, 'A', 3);

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (3, 'A', 2, 'b');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (3, 'Z', 2, 'be');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (4, 'E', 2, 'c');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (5, 'Z', 3, 'd');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (6, 'Z', 3, 'e');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (7, 'E', 3, 's');

insert
into Aspiration (C_id, S_code, score, test_T_id)
values    (8, 'O', 1, 't');

-- town records
insert
into Town (T_id, T_name, Mayor_C_id, Biggest_Rival_T_id)
values    ('a', 'Anoka', 2, 'be');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('b', 'Bemidji', 'd');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('be', 'Blue Earth', 'c');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('c', 'Chaska', 'a');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('d', 'Duluth', 'b');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('e', 'Edina', 'h');

insert
into Town (T_id, T_name)
values    ('em', 'Embarrass');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('h', 'Hollywood', 'p');

insert
into Town (T_id, T_name, Biggest_Rival_T_id)
values    ('p', 'Philly', 'd');

insert
into Town (T_id, T_name)
values    ('s', 'Swampville');

insert
into Town (T_id, T_name)
values    ('t', 'Tokyo');


-- job records
insert
into Job  (J_code, J_desc)
values    ('Survivor', 'can stay alive in water');

insert
into Job  (J_code, J_desc)
values    ('Beach_Bum', 'lives cheaply');

insert
into Job  (J_code, J_desc)
values    ('Brother_In_Law', 'does nothing');


-- job vary records, varying DEMONS-ZA
insert
into JobVD (J_code, J_desc, Vary)
values     ('Survivor', 'can stay alive in water', 'EM');

insert
into JobVD (J_code, J_desc, Vary)
values     ('Beach_Bum', 'lives cheaply', 'E');

insert
into JobVD (J_code, J_desc, Vary)
values     ('Brother_in_Law', 'does nothing', 'M');


-- job vary records, varying counts expressions
insert
into JobVC (J_code, J_desc, Vary)
values     ('Survivor', 'can stay alive in water',
            '(QCount > MQCount)' );

insert
into JobVC (J_code, J_desc, Vary)
values     ('Beach_Bum', 'lives cheaply',
            '(QCount = 1)' );

insert
into JobVC (J_code, J_desc, Vary)
values     ('Brother_in_Law', 'does nothing',
            '(QCount = 0)' );


-- job vary records, varying range expressions
insert
into JobVR (J_code, J_desc, Range_Test)
values     ('Survivor', 'can stay alive in water',
            '(S_code > S_code_lo)' );

insert
into JobVR (J_code, J_desc, Range_Test)
values     ('Beach_Bum', 'lives cheaply',
            '(S_code < S_code_hi)' );

insert
into JobVR (J_code, J_desc, Range_Test)
values     ('Brother_in_Law', 'does nothing',
            '((S_code > S_code_lo) AND (S_code < S_code_hi))' );


-- job vary records, varying DEMONS-ZA and range expressions
insert
into JobVDVR (J_code, J_desc, Vary, Range_Test)
values       ('Survivor', 'can stay alive in water', 'EM',
              '(S_code > S_code_lo)' );

insert
into JobVDVR (J_code, J_desc, Vary, Range_Test)
values       ('Beach_Bum', 'lives cheaply', 'E',
              '(S_code < S_code_hi)' );

insert
into JobVDVR (J_code, J_desc, Vary, Range_Test)
values       ('Brother_in_Law', 'does nothing', 'M',
              '((S_code > S_code_lo) AND (S_code < S_code_hi))' );


-- job vary records, varying counts and range expressions
insert
into JobVCVR (J_code, J_desc, Vary, Range_Test)
values        ('Survivor', 'can stay alive in water', '(QCount > MQCount)',
               '(S_code > S_code_lo)' );

insert
into JobVCVR (J_code, J_desc, Vary, Range_Test)
values        ('Beach_Bum', 'lives cheaply', '(QCount = 1)',
               '(S_code < S_code_hi)' );

insert
into JobVCVR (J_code, J_desc, Vary, Range_Test)
values        ('Brother_in_Law', 'does nothing', '(QCount = 0)',
               '((S_code > S_code_lo) AND (S_code < S_code_hi))' );


-- job_skill records
insert
into Job_Skill  (J_code, S_code)
values    ('Survivor', 'A');

insert
into Job_Skill  (J_code, S_code)
values    ('Survivor', 'E');

insert
into Job_Skill  (J_code, S_code)
values    ('Beach_Bum', 'Z');


-- job_skill_range records
insert
into Job_Skill_Range  (J_code, S_code_lo, S_code_hi)
values                ('Survivor', 'A', 'C');

insert
into Job_Skill_Range  (J_code, S_code_lo, S_code_hi)
values                ('Survivor', 'D', 'F');

insert
into Job_Skill_Range  (J_code, S_code_lo, S_code_hi)
values                ('Beach_Bum', 'Z', 'Z');


-- job_skill_score records
insert
into Job_Skill_Score (J_code, S_code2, Score2)
values               ('Survivor', 'A', 3);

insert
into Job_Skill_Score (J_code, S_code2, Score2)
values               ('Survivor', 'E', 2);

insert
into Job_Skill_Score (J_code, S_code2, Score2)
values               ('Beach_Bum', 'Z', 2);


-- job_skill_score_range records
insert
into Job_Skill_Score_Range (J_code, S_code2, Score_lo, Score_hi)
values                     ('Survivor', 'A', 2, 3);

insert
into Job_Skill_Score_Range (J_code, S_code2, Score_lo, Score_hi)
values                     ('Survivor', 'E', 1, 2);

insert
into Job_Skill_Score_Range (J_code, S_code2, Score_lo, Score_hi)
values                     ('Beach_Bum', 'Z', 2, 2);


-- job_skill_range vary records
insert
into Job_Skill_RangeV (J_code, S_code_lo, S_code_hi, Range_Test)
values                ('Survivor', 'A', 'C',
                       '(S_code > S_code_lo)' );

insert
into Job_Skill_RangeV (J_code, S_code_lo, S_code_hi, Range_Test)
values                ('Survivor', 'D', 'F',
                       '(S_code < S_code_hi)' );

insert
into Job_Skill_RangeV (J_code, S_code_lo, S_code_hi, Range_Test)
values                ('Beach_Bum', 'Z', 'Z',
                       '((S_code >= S_code_lo) AND (S_code <= S_code_hi))' );


-- survivor records
insert
into Survivor   (S_code)
values          ('A');

insert
into Survivor   (S_code)
values          ('E');



