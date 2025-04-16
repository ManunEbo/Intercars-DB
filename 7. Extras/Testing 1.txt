Use icp;
/*Insert into Staff: insert via trigger into icp.Names, icp.Contact_details*/
select * from icp.Staff;
select * from icp.names;
select * from icp.contact_details;

Delete from icp.staff
where Staff_id=2;

select "Nara" into @Fname ;
select "Senton" into @Mname ;
select "Manun'Ebo" into @Lname ;
select "35" into @Addr1;
select "Willow Street" into @Addr2;
select "Leicester" into @Addr3;
select "Leicestershire" into @Addr4;
select "England" into @Addr5;
select "LE1 2HR" into @Addr6;
select "Nara123@hotmail.com" into @email;
select "07710686060" into @tel;
insert into icp.Staff(DOB)Values('1992/09/08');

select @Fname,@Mname,@Lname,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@tel;
set @Addr1="";
set @Addr2="";
set @Addr3="";
set @Addr4="";
set @Addr5="";
set @Addr6="";
set @email="";
set @tel="";
set @Fname="";
set @Mname="";
set @Lname="";

select * from icp.v5c;

				/*********** Service_History **********/
/*Extracting the V5C_id*/
select v5c_id into @v5c_id1 from icp.v5c where Reg_numb="YD14 XUU";
select @v5c_id1 ;
/******** Insert into Service history *************/
insert into icp.Service_History(V5C_id,Vehicle_Reg_serv_Date,Serv_comp,
Serv_Addr,Serv_Date,Serv_Parts_desc,Quantity,Unit_price,Sum_per_Parts,
Total_Labour,Total_Parts,MOT_Fee,VAT,Grand_Total)
values(@v5c_id1,
"YD14 XUU","Coil Motors","3 Huckerbey Drive Roston Leicestershire LE15 7BX",
"2020/04/17","Cambelt warn out", 1, 150, 150, 40,  180, 32, 30, 252);

select * from icp.Service_History;

delete from icp.Service_History
where Serv_Hist_id=1;

					/********* MOT History ********/
/*Extracting the V5C_id in preparation for insert into MOT_History*/
select v5c_id into @v5c_id1 from icp.v5c where Reg_numb="YD14 XUU";
select @v5c_id1;
/********** Insert into MOT_History **************/
Insert into icp.MOT_History(V5C_ID,Vehicle_Reg_MOT_Date,Test_Org,Test_Addr,
Test_Date,Expiry_date,Advisory1,Advisory2,Advisory3,Advisory4,Advisory5,
MOT_tst_Cert_Nbr,Price)
values(@v5c_id1,"YD14 XUU","Super Mario Motors","2 Sharkshitting on OS Drive Leicester LE2 2BZ",
		"2020/02/02", "2021/02/01","Tires shitting their pants but hiding it. I think we bloody stuck mate",
        "","","","", 48937578375,32);

select * from icp.MOT_History;

/****************** MOT Refusal ******************/
desc icp.MOT_Refusal;

/*Extracting the V5C_id in preparation for insert into MOT_History*/
select v5c_id into @v5c_id1 from icp.v5c where Reg_numb="YD14 XUU";
/*****************Insert into icp.MOT_Refusal*/
select @v5c_id1;
insert into icp.mot_refusal(V5C_id,Vehicle_Reg_MOT_Date,Test_comp,Test_Addr,
Test_Date,Ref_Reason1,Ref_Reason2,Ref_Reason3,Ref_Reason4,Ref_Reason5)
VALUES(@v5c_id1,"YD14 XUU","Super Mario Motors","2 Sharkshitting on OS Drive Leicester LE2 2BZ",
"2019/02/22","Mario didn't want to get ran over","","","","");
select * from icp.Mot_refusal;
delete from icp.Mot_refusal
where Mot_refusal_id=1;

/*Mileage History*/
Select * from icp.Mileage_History;
desc icp.Mileage_History;
desc icp.v5c;
/*Extracting the V5C_id in preparation for insert into MOT_History*/
select v5c_id into @v5c_id1 from icp.v5c where Reg_numb="YD14 XUU";

insert into icp.Mileage_History(V5C_id,Vehicle_Reg_MOT_Date,Source,Mileage,Date)
Values(@v5c_id1,"YD14 XUU","Gov.UK",110400,"2020/06/04");

Select * from icp.Mileage_History;

delete from icp.mileage_history
where Mileage_Hist_id=1;

select @test:="testing 123";

