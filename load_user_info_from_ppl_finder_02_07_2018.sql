-- Dumping structure for procedure pips_uat.load_user_info_from_ppl_finder_1
DROP PROCEDURE IF EXISTS `load_user_info_from_ppl_finder_1`;
DELIMITER //
CREATE PROCEDURE `load_user_info_from_ppl_finder_1`()
BEGIN
drop table if exists user_info_clone;
CREATE TABLE `user_info_clone` (
  `id_user` bigint(20) NOT NULL AUTO_INCREMENT,  
  `employee_id` bigint(20) DEFAULT NULL,
  `bank_id` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `preferred_name` varchar(255) DEFAULT NULL,
  `nric` varchar(255) DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `org_structure_level_1` varchar(255) DEFAULT NULL,
  `org_structure_level_2` varchar(255) DEFAULT NULL,
  `org_structure_level_3` varchar(255) DEFAULT NULL,
  `level3_descr` varchar(255) DEFAULT NULL,
  `org_structure_level_4` varchar(255) DEFAULT NULL,
  `level4_descr` varchar(255) DEFAULT NULL,
  `org_structure_level_5` varchar(255) DEFAULT NULL,
  `level5_descr` varchar(255) DEFAULT NULL,
  `org_structure_level_6` varchar(255) DEFAULT NULL,
  `level6_descr` varchar(255) DEFAULT NULL,
  `org_structure_level_7` varchar(255) DEFAULT NULL,
  `level7_descr` varchar(255) DEFAULT NULL,
  `org_structure_level_8` varchar(255) DEFAULT NULL,
  `level8_descr`  varchar(255) DEFAULT NULL,
  `org_structure_level_9` varchar(255) DEFAULT NULL,
  `level9_descr` varchar(255) DEFAULT NULL,
  `org_structure_level_10` varchar(255) DEFAULT NULL,
  `level10_descr` varchar(255) DEFAULT NULL,
  `rank` varchar(255) DEFAULT NULL,
  `job_code` varchar(255) DEFAULT NULL,
  `job_code_descr` varchar(255) DEFAULT NULL,
  `country_manager_id` bigint(20) DEFAULT NULL,
  `preffered_name_of_country_manager` varchar(255) DEFAULT NULL,
  `regular_temporary` char(1) DEFAULT NULL,
  `full_time_part_time` char(1) DEFAULT NULL,
  `business_title` varchar(255) DEFAULT NULL,
  `lan_id` varchar(255) DEFAULT NULL,
  `regional_manager_id` bigint(20) DEFAULT NULL,
  `pref_name_of_regional_bu_manager` varchar(255) DEFAULT NULL,
  `local_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
alter table user_info_clone add  unique (bank_id);

END//
DELIMITER ;


-- Dumping structure for procedure pips_uat.load_user_info_from_ppl_finder_2
DROP PROCEDURE IF EXISTS `load_user_info_from_ppl_finder_2`;
DELIMITER //
CREATE PROCEDURE `load_user_info_from_ppl_finder_2`()
BEGIN
DECLARE country_code_v varchar(255);
DECLARE company_code_v varchar(255);
DECLARE org_structure_level_4_code_v varchar(255);
DECLARE org_structure_level_5_code_v varchar(255);
DECLARE org_structure_level_4_desc_v varchar(255);
DECLARE org_structure_level_5_desc_v varchar(255);
DECLARE level_6_code_v varchar(255);
DECLARE level_6_desc_v varchar(255);
DECLARE level_7_code_v varchar(255);
DECLARE level_7_desc_v varchar(255);
DECLARE level_8_code_v varchar(255);
DECLARE level_8_desc_v varchar(255);
DECLARE level_9_code_v varchar(255);
DECLARE level_9_desc_v varchar(255);
DECLARE level_10_code_v varchar(255);
DECLARE level_10_desc_v varchar(255);
declare exis_country_code_v varchar(255);
DECLARE dept_code_v varchar(255);
DECLARE dept_name_v varchar(255);
declare exis_dept_code_v varchar(255);
declare temp_counter_v bigint(20);
declare country_id_v bigint(20);
declare id_bank_v varchar(255);
declare dept_id_v bigint(20);
declare dept_row_count_v bigint(20);
declare ctr_v bigint(20);
declare country_row_count_v bigint(20);
declare country_ctr bigint(20);
declare todays_date date;
DECLARE countries_exit,departments_exit,users_exit BOOLEAN default false;
DECLARE exit handler for sqlexception
  BEGIN
    
    SHOW ERRORS LIMIT 1;
  ROLLBACK;
  
END;

START TRANSACTION;
 block_country:begin
 
 

 select count(distinct(org_structure_level_1)) from user_info_clone into country_row_count_v;
 select concat('country loop begins');
 select concat('country_row_count_v  : ',country_row_count_v);
 set country_ctr=0;
 while country_ctr < country_row_count_v do
     set temp_counter_v = NULL;
     select max(id_country) from country into temp_counter_v;
     set temp_counter_v  = temp_counter_v +1;
     
	 set country_code_v=null;
     set exis_country_code_v=NULL;
		select distinct(org_structure_level_1) from user_info_clone  limit country_ctr,1 into country_code_v;
		select iso2_code from country where iso2_code=country_code_v limit 0,1 into exis_country_code_v;
     if exis_country_code_v is NULL then
		insert into country(id_country,iso2_code) values(temp_counter_v,country_code_v);
     end if;
		set country_ctr = country_ctr+1;
 end while;

end block_country;
     
    block_department:begin 
    
	select count(*) from user_info_clone where id_user is not null into dept_row_count_v;
   select concat('department loop begins');
   select concat('dept_row_count_v  : ',dept_row_count_v);
   set ctr_v = 0;
   while ctr_v < dept_row_count_v do
    set dept_code_v=null,dept_name_v=null,country_code_v=NULL,country_id_v=null;
    set exis_dept_code_v=NULL;
	select concat('ctr_v  : ',ctr_v);
	select org_structure_level_3,level3_descr,org_structure_level_1,org_structure_level_2,org_structure_level_4,org_structure_level_5,level4_descr,level5_descr,org_structure_level_6,level6_descr,org_structure_level_7,level7_descr,org_structure_level_8,level8_descr,org_structure_level_9,level9_descr,org_structure_level_10,level10_descr from user_info_clone limit ctr_v,1 into dept_code_v,dept_name_v,country_code_v,company_code_v,org_structure_level_4_code_v,org_structure_level_5_code_v,org_structure_level_4_desc_v,org_structure_level_5_desc_v,level_6_code_v,level_6_desc_v,level_7_code_v,level_7_desc_v,level_8_code_v,level_8_desc_v,level_9_code_v,level_9_desc_v,level_10_code_v,level_10_desc_v;
	 
	  select concat('dept_code_v  : ',dept_code_v);
	  select concat('dept_name_v  : ',dept_name_v);
	  select concat('country_code_v  : ',country_code_v);
	  select concat('company_code_v  : ',company_code_v);
	  select concat('org_structure_level_4_code_v  : ',org_structure_level_4_code_v);
	  select concat('org_structure_level_5_code_v  : ',org_structure_level_5_code_v);
	  select concat('org_structure_level_6_code_v  : ',level_6_code_v);
	  select concat('org_structure_level_7_code_v  : ',level_7_code_v);
	  select concat('org_structure_level_8_code_v  : ',level_8_code_v);
	  select concat('org_structure_level_9_code_v  : ',level_9_code_v);
	  select concat('org_structure_level_10_code_v  : ',level_10_code_v);
    set temp_counter_v = NULL;
     select max(id_department) from department into temp_counter_v;
     set temp_counter_v  = temp_counter_v +1;	 
		select id_country from country where iso2_code=country_code_v limit 0,1 into country_id_v;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4='' and org_structure_level_5='' and org_structure_level_6='' and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,'','','','','','','','','','','','','','');
			set temp_counter_v  = temp_counter_v +1;	
		else
		  update department set name=dept_name_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4='' and org_structure_level_5='' and org_structure_level_6='' and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='';

		end if;  
		
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5='' and org_structure_level_6='' and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,'','','','','','','','','','','','');
			set temp_counter_v  = temp_counter_v +1;
		else
		   update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5='' and org_structure_level_6='' and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='';

		end if;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6='' and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,org_structure_level_5_code_v,org_structure_level_5_desc_v,'','','','','','','','','','');
			set temp_counter_v  = temp_counter_v +1;
		else
			update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v ,org_structure_level_5_desc=org_structure_level_5_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6='' and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='';

		end if;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,org_structure_level_5_code_v,org_structure_level_5_desc_v,level_6_code_v,level_6_desc_v,'','','','','','','','');
			set temp_counter_v  = temp_counter_v +1;
		else
		    update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v ,org_structure_level_5_desc=org_structure_level_5_desc_v,org_structure_level_6_desc=level_6_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7='' and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='';

		end if;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,org_structure_level_5_code_v,org_structure_level_5_desc_v,level_6_code_v,level_6_desc_v,level_7_code_v,level_7_desc_v,'','','','','','');
			set temp_counter_v  = temp_counter_v +1;
		else
		    update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v ,org_structure_level_5_desc=org_structure_level_5_desc_v,org_structure_level_6_desc=level_6_desc_v,org_structure_level_7_desc=level_7_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8='' and org_structure_level_9='' and org_structure_level_10='';

		end if;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9='' and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,org_structure_level_5_code_v,org_structure_level_5_desc_v,level_6_code_v,level_6_desc_v,level_7_code_v,level_7_desc_v,level_8_code_v,level_8_desc_v,'','','','');
			set temp_counter_v  = temp_counter_v +1;
		else
			update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v ,org_structure_level_5_desc=org_structure_level_5_desc_v,org_structure_level_6_desc=level_6_desc_v,org_structure_level_7_desc=level_7_desc_v,org_structure_level_8_desc=level_8_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9='' and org_structure_level_10='';

		end if;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9=level_9_code_v and org_structure_level_10='' limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,org_structure_level_5_code_v,org_structure_level_5_desc_v,level_6_code_v,level_6_desc_v,level_7_code_v,level_7_desc_v,level_8_code_v,level_8_desc_v,level_9_code_v,level_9_desc_v,'','');
			set temp_counter_v  = temp_counter_v +1;
		else
			update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v ,org_structure_level_5_desc=org_structure_level_5_desc_v,org_structure_level_6_desc=level_6_desc_v,org_structure_level_7_desc=level_7_desc_v,org_structure_level_8_desc=level_8_desc_v,org_structure_level_9_desc=level_9_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9=level_9_code_v and org_structure_level_10='';

		end if;
		set exis_dept_code_v = null;
		select code from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9=level_9_code_v and org_structure_level_10=level_10_code_v limit 0,1 into exis_dept_code_v;
		if exis_dept_code_v is NULL then
			select concat('country_code_v : ',country_code_v);
			
			select concat('country_id_v : ',country_id_v);
			insert into department(id_department,is_active,code,name,fk_country,company,org_structure_level_4,org_structure_level_4_desc,org_structure_level_5,org_structure_level_5_desc,org_structure_level_6,org_structure_level_6_desc,org_structure_level_7,org_structure_level_7_desc,org_structure_level_8,org_structure_level_8_desc,org_structure_level_9,org_structure_level_9_desc,org_structure_level_10,org_structure_level_10_desc) values(temp_counter_v,1,dept_code_v,dept_name_v,country_id_v,company_code_v,org_structure_level_4_code_v,org_structure_level_4_desc_v,org_structure_level_5_code_v,org_structure_level_5_desc_v,level_6_code_v,level_6_desc_v,level_7_code_v,level_7_desc_v,level_8_code_v,level_8_desc_v,level_9_code_v,level_9_desc_v,level_10_code_v,level_10_desc_v);
			set temp_counter_v  = temp_counter_v +1;
		else
			update department set name=dept_name_v, org_structure_level_4_desc=org_structure_level_4_desc_v ,org_structure_level_5_desc=org_structure_level_5_desc_v,org_structure_level_6_desc=level_6_desc_v,org_structure_level_7_desc=level_7_desc_v,org_structure_level_8_desc=level_8_desc_v,org_structure_level_9_desc=level_9_desc_v,org_structure_level_10_desc=level_10_desc_v where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9=level_9_code_v and org_structure_level_10=level_10_code_v;

		end if;
		
	set ctr_v = ctr_v+1;
   end while;
select concat('department loop ends');
end block_department;

 DROP TEMPORARY TABLE IF EXISTS tmp_table1;
 create temporary table  tmp_table1(bank_id varchar(255));
 insert into tmp_table1(bank_id)  select bank_id from user;
update user u set u.is_active=1 where u.bank_id in (select uic.bank_id from user_info_clone uic ) and u.is_active=0;
insert into user(is_active,is_covered,bank_id,nric)  select 1,1,uic.bank_id,uic.nric from user_info ui right outer join user_info_clone uic on ui.bank_id=uic.bank_id where ui.bank_id is NULL and uic.bank_id not in(select t.bank_id from tmp_table1 t );
update user set covered_date=curdate() where covered_date is null;
update user set created_date=curdate() where created_date is null;

select concat('CURSOR USER starts');
    block_user:begin 
   DECLARE users_cur CURSOR FOR select bank_id as id_bank_v,org_structure_level_3 as dept_code_v,org_structure_level_1 as country_code_v, org_structure_level_2 as company_code_v,org_structure_level_4 as org_structure_level_4_code_v,org_structure_level_5 as org_structure_level_5_code_v,org_structure_level_6 as level_6_code_v,org_structure_level_7 as level_7_code_v,org_structure_level_8 as level_8_code_v,org_structure_level_9 as level_9_code_v,org_structure_level_10 as level_10_code_v from user_info_clone where id_user is not null;

 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET users_exit = TRUE;
   
 OPEN users_cur;
   
   select concat('users count : ',(select count(*) from user_info_clone where id_user is not null));
   select concat('users loop begins');
   select concat('users_cur list size: ',found_rows());
 user_loop: LOOP
 
     
	 set dept_code_v=null,dept_id_v=null,country_code_v=NULL,country_id_v=null,id_bank_v=null,company_code_v=null,org_structure_level_4_code_v=null,org_structure_level_5_code_v=null,level_6_code_v=null,level_7_code_v=null,level_8_code_v=null,level_9_code_v=null,level_10_code_v=null;
   
     FETCH  users_cur INTO id_bank_v,dept_code_v,country_code_v,company_code_v,org_structure_level_4_code_v,org_structure_level_5_code_v,level_6_code_v,level_7_code_v,level_8_code_v,level_9_code_v,level_10_code_v;
     select concat('id_bank_v : ',id_bank_v);
     select concat('dept_code_v : ',dept_code_v);
     select concat('country_code_v : ',country_code_v);
	 if id_bank_v is NULL then
                leave user_loop;
     end if;
     select concat('bank_id : ',id_bank_v);
     select id_country from country where iso2_code=country_code_v limit 0,1 into country_id_v;
	 select id_department from department where code=dept_code_v and company=company_code_v and fk_country=country_id_v and org_structure_level_4=org_structure_level_4_code_v and org_structure_level_5=org_structure_level_5_code_v and org_structure_level_6=level_6_code_v and org_structure_level_7=level_7_code_v and org_structure_level_8=level_8_code_v and org_structure_level_9=level_9_code_v and org_structure_level_10=level_10_code_v limit 0,1 into dept_id_v;
     if country_id_v is not NULL and dept_id_v is not null then
		update user u set u.fk_department=dept_id_v,u.fk_country=country_id_v where u.bank_id=id_bank_v;
     end if;     
IF users_exit THEN
         CLOSE users_cur;
         LEAVE user_loop;
     END IF;
END LOOP user_loop;
 select concat('users loop ends');
end block_user;

-- delete from user_info_clone u1, user_info_clone u2 where u1.id_user > u2.id_user and u1.bank_id = u2.bank_id;

insert into user_info(employee_id,first_name,last_name,preferred_name,gender,org_structure_level_1,org_structure_level_2,org_structure_level_3,level3_descr,org_structure_level_4,level4_descr,org_structure_level_5,level5_descr,org_structure_level_6,level6_descr,org_structure_level_7,level7_descr,org_structure_level_8,level8_descr,org_structure_level_9,level9_descr,org_structure_level_10,level10_descr,rank,job_code,job_code_descr,email,country_manager_id,preffered_name_of_country_manager,nric,regular_temporary,full_time_part_time,business_title,lan_id,regional_manager_id,pref_name_of_regional_bu_manager,local_name,bank_id)
select uic.employee_id,uic.first_name,uic.last_name,uic.preferred_name,uic.gender,uic.org_structure_level_1,uic.org_structure_level_2,uic.org_structure_level_3,uic.level3_descr,uic.org_structure_level_4,uic.level4_descr,uic.org_structure_level_5,uic.level5_descr,uic.org_structure_level_6,uic.level6_descr,uic.org_structure_level_7,uic.level7_descr,uic.org_structure_level_8,uic.level8_descr,uic.org_structure_level_9,uic.level9_descr,uic.org_structure_level_10,uic.level10_descr,uic.rank,uic.job_code,uic.job_code_descr,uic.email,uic.country_manager_id,uic.preffered_name_of_country_manager,uic.nric,uic.regular_temporary,uic.full_time_part_time,uic.business_title,uic.lan_id,uic.regional_manager_id,uic.pref_name_of_regional_bu_manager,uic.local_name,uic.bank_id
from user_info_clone uic left outer join user_info ui on ui.bank_id=uic.bank_id where ui.bank_id is null;

update user_info u_i join user_info_clone u_i_c on u_i.bank_id = u_i_c.bank_id
	SET u_i.employee_id = u_i_c.employee_id,
	u_i.first_name = u_i_c.first_name,
	u_i.last_name = u_i_c.last_name,
	u_i.preferred_name = u_i_c.preferred_name,
	u_i.gender = u_i_c.gender, 
	u_i.org_structure_level_1 = u_i_c.org_structure_level_1,
	u_i.org_structure_level_2 = u_i_c.org_structure_level_2,
	u_i.org_structure_level_3 = u_i_c.org_structure_level_3,
	u_i.level3_descr = u_i_c.level3_descr,
	u_i.org_structure_level_4 = u_i_c.org_structure_level_4,
	u_i.level4_descr = u_i_c.level4_descr,
	u_i.org_structure_level_5 = u_i_c.org_structure_level_5,
	u_i.level5_descr = u_i_c.level5_descr,
	u_i.org_structure_level_6 = u_i_c.org_structure_level_6,
	u_i.level6_descr = u_i_c.level6_descr,
	u_i.org_structure_level_7 = u_i_c.org_structure_level_7,
	u_i.level7_descr = u_i_c.level7_descr,
	u_i.org_structure_level_8 = u_i_c.org_structure_level_8,
	u_i.level8_descr = u_i_c.level8_descr,
	u_i.org_structure_level_9 = u_i_c.org_structure_level_9,
	u_i.level9_descr = u_i_c.level9_descr,
	u_i.org_structure_level_10 = u_i_c.org_structure_level_10,
	u_i.level10_descr = u_i_c.level10_descr,
	u_i.rank = u_i_c.rank,
	u_i.job_code = u_i_c.job_code,
	u_i.job_code_descr = u_i_c.job_code_descr,
	u_i.email = u_i_c.email,
	u_i.country_manager_id = u_i_c.country_manager_id,
	u_i.preffered_name_of_country_manager = u_i_c.preffered_name_of_country_manager,
	u_i.nric = u_i_c.nric,
	u_i.regular_temporary = u_i_c.regular_temporary,
	u_i.full_time_part_time = u_i_c.full_time_part_time,
	u_i.business_title = u_i_c.business_title,
	u_i.lan_id = u_i_c.lan_id,
	u_i.regional_manager_id = u_i_c.regional_manager_id,
	u_i.pref_name_of_regional_bu_manager = u_i_c.pref_name_of_regional_bu_manager,
	u_i.local_name = u_i_c.local_name;

drop table user_info_clone;
UPDATE user_info JOIN user ON user_info.bank_id = user.bank_id
  SET user_info.fk_user = user.id_user where user_info.fk_user is null;
COMMIT;
END//
DELIMITER ;