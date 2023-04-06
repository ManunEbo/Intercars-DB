use icp;

-- drop trigger if exists Staff_insert;
drop trigger if exists Staff_insert;
Delimiter /
create trigger Staff_insert  after insert
on icp.Staff
for each row
Begin 
-- Insert into names
Insert into icp.Names(Staff_id,Fname,Mname,Lname)
values(new.Staff_id,@Fname,@Mname,@Lname);

-- insert into DOB
Insert into icp.DOB(Staff_id,DOB,Age_Group)
values(new.Staff_id,@DOB,@Age_Group);

-- Insert into contact details
Insert into icp.Contact_details(Staff_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
values(new.Staff_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@tel);

end /
delimiter ;