CREATE TABLE product (
       product_name     VARCHAR2(25) PRIMARY KEY,
       product_price    NUMBER(4,2),
       quantity_on_hand NUMBER(5,0),
       last_stock_date  DATE
        );

INSERT INTO product VALUES ('Product 1', 99,  1,    '15-JAN-03');
INSERT INTO product VALUES ('Product 2', 75,  1000, '15-JAN-02');
INSERT INTO product VALUES ('Product 3', 50,  100,  '15-JAN-03');
INSERT INTO product VALUES ('Product 4', 25,  10000, null);
INSERT INTO product VALUES ('Product 5', 9.95,1234, '15-JAN-04');
INSERT INTO product VALUES ('Product 6', 45,  1, TO_DATE('December 31, 2008, 11:30 P.M.','Month dd, YYYY, HH:MI P.M.'));

DECLARE
          CURSOR product_cur IS
          SELECT * FROM product
          FOR UPDATE OF product_price;
BEGIN
          FOR product_rec IN product_cur
          LOOP
                  UPDATE product
                  SET product_price = (product_rec.product_price * 0.97)
                  WHERE CURRENT OF product_cur;
          END LOOP;
END;
/

select * from product;
drop table product;


create table Employee(
   ID                 VARCHAR2(4 BYTE) NOT NULL,
   First_Name         VARCHAR2(10 BYTE),
   Last_Name          VARCHAR2(10 BYTE),
   Start_Date         DATE,
   Salary             Number(8,2),
   Description        VARCHAR2(15 BYTE)
  );

-- prepare data
insert into Employee(ID, First_Name, Last_Name, Start_Date, Salary, Description)
  values ('01','Jason', 'Martin', to_date('19960725','YYYYMMDD'), 1234.56, 'Programmer');
insert into Employee(ID, First_Name, Last_Name, Start_Date, Salary, Description)
  values('02','Alison', 'Mathews', to_date('19760321','YYYYMMDD'), 6661.78, 'Tester');

-- display data in the table
select * from Employee;

declare
      type number_nt is table of VARCHAR(20);
      v_deptNo_nt number_nt:=number_nt('05','06');
  begin
      forall i in v_deptNo_nt.first()..v_deptNo_nt.last()
        insert into Employee(ID, First_Name, Last_Name, Start_Date, Salary, Description)
        values(v_deptNo_nt(i),'Celia', 'Rice', to_date('19821024','YYYYMMDD'), 2344.78, 'Manager');
        --update employee set salary = 0 where id =v_deptNo_nt(i);
  end;
/

select * from Employee;
drop table Employee;
--select major activities for gent order by # of tariffs in them

 select activity_id, count(*) as tot_tariffs
 from ns_tariff where activity_id in
 (
      select activity_id from ns_activity
      where internal_companynr = 120012 and type = 1
 )
 group by activity_id order by tot_tariffs desc;

Here is the working script:

--select major activities for gent order by # of tariffs in them
create table res1
(
  activity_id number,
  tot_tariffs number
);
declare
  v_int_companynr number := 120012; -- gent
  v_activity_type number := 1; -- major
begin
insert into res1 (activity_id, tot_tariffs)
 select activity_id, count(*) as tot_tariffs
 from ns_tariff where activity_id in
 (
      select activity_id from ns_activity
      where internal_companynr = v_int_companynr and type = v_activity_type
 )
 group by activity_id;
end;
/
select * from res1 order by tot_tariffs desc;
drop table res1;
DECLARE
  hundreds_counter  NUMBER(1,-2);
BEGIN
  hundreds_counter := 100;
  LOOP
    DBMS_OUTPUT.PUT_LINE(hundreds_counter);
     hundreds_counter := hundreds_counter + 100;
   END LOOP;
 EXCEPTION
 WHEN OTHERS THEN
   DBMS_OUTPUT.PUT_LINE('That is as high as you can go.');
END;
/
                DetachedCriteria productGroups =
                    DetachedCriteria.For<ProductGroup>().
                    CreateCriteria("ProductGroupCompanies").
                    Add(Expression.In
                    ("company.Id", filter.InternalCompanyIds)).
                    SetProjection(Projections.Id());

                criteria.Add(Subqueries.PropertyIn("ProductGroup.Id", productGroups));

SELECT this_0_.CHECKLIST_RELATION_ID as y0_
FROM   NS_CHECKLIST_RELATION this_0_
where this_0_.PRODUCT_GROUP_ID in (SELECT this_0_0_.PRODUCT_GROUP_ID as y0_
FROM   WMS_PRODUCT_GROUP this_0_0_
  inner join WMS_PRODUCT_GROUP_COMPANY productgro1_
    on this_0_0_.PRODUCT_GROUP_ID = productgro1_.PRODUCT_GROUP_ID
WHERE  productgro1_.COMPANYNR in (3 /* :p2 */,134962 /* :p3 */,11529 /* :p4 */,12792 /* :p5 */,
                             135478 /* :p6 */,120012 /* :p7 */,9 /* :p8 */,267918 /* :p9 */,
                             425657 /* :p10 */,128083 /* :p11 */))   

stockdaonhibernate

            if (filter.CorrectionExists.HasValue)
            {
                if (filter.CorrectionExists.Value)
                {
                    EnsureCriteria(criteria, "FinalInCorrections");
                }
                else
                {
                    // Do not change the StockType is null!!!!!!!!!
                    // There is a problem with Oracle
                    // if the query works with Stock_Id!!!!!!!!
                    EnsureCriteria(criteria,
                        "FinalInCorrections[join:leftouter]").
                            Add(Expression.IsNull("StockType"));
                }
            }
declare
  type number_nt is table of number(10);
  v_rptCompIDs number_nt:=number_nt(12792,134962,267918,425657);
begin
  forall i in v_rptCompIDs.first()..v_rptCompIDs.last()
    insert into report_description
      (report_description_id, report_core_id, usage, internal_companynr,
      create_user, create_timestamp, update_user, update_timestamp, printer_duplex)
    values
      (SEQ_REPORT_DESCRIPTION.NEXTVAL, 73, 'ReportingHeader', v_rptCompIDs(i),
      'script', sysdate, 'script', sysdate, 0);
end;
/
commit;
CREATE TABLE lecturer (
    id               NUMBER(5) PRIMARY KEY,
    first_name       VARCHAR2(20),
    last_name        VARCHAR2(20),
    major            VARCHAR2(30),
    current_credits  NUMBER(3)
    );

INSERT INTO lecturer (id, first_name, last_name, major,current_credits)
                VALUES (10001, 'Scott', 'Lawson','Computer Science', 11);

INSERT INTO lecturer (id, first_name, last_name, major, current_credits)
                VALUES (10002, 'Mar', 'Wells','History', 4);

INSERT INTO lecturer (id, first_name, last_name, major,current_credits)
                VALUES (10003, 'Jone', 'Bliss','Computer Science', 8);

INSERT INTO lecturer (id, first_name, last_name, major,current_credits)
                VALUES (10004, 'Man', 'Kyte','Economics', 8);

INSERT INTO lecturer (id, first_name, last_name, major,current_credits)
                VALUES (10005, 'Pat', 'Poll','History', 4);
                
select * from lecturer;

DECLARE
    v_NewMajor VARCHAR2(10) := 'History';
    myFirstName VARCHAR2(10) := 'Scott';
    v_LastName VARCHAR2(10) := 'Urman';
  BEGIN
    UPDATE lecturer
      SET major = v_NewMajor
      WHERE first_name = myFirstName
      AND last_name = v_LastName;
    IF SQL%NOTFOUND THEN
      INSERT INTO lecturer (ID, first_name, last_name, major)
        VALUES (10020, myFirstName, v_LastName, v_NewMajor);
    END IF;
  END;
/
 
select * from lecturer;

drop table lecturer; 
DECLARE
    v_RailCarID NUMBER;
    v_WagonID NUMBER;
  BEGIN
    select config_setting_id into v_WagonID
      from config_setting
      where key like 'WagonTypeTransportProperty';
    select config_setting_id into v_RailCarID
      from config_setting
      where key like 'RailCarTransportType';
    select config_setting_id into v_WagonID
      from config_setting
      where key like 'TruckTransportType';
    select config_setting_id into v_RailCarID
      from config_setting
      where key like 'BaseCurrency';
    DBMS_OUTPUT.PUT_LINE(v_WagonID);

  END;
/
CREATE TABLE orders (
  descr varchar(10),
  id NUMBER
);

DECLARE
    rptDateFrom DATE := to_date('2009/05/01', 'yyyy/mm/dd');
    rptDateTo DATE := to_date('2019/06/01', 'yyyy/mm/dd');
    numODs NUMBER;
    numPendings NUMBER;
    numFinals NUMBER;
    numTransportsFrom NUMBER;
    numTransportsTo NUMBER;
    
BEGIN

insert into orders(id)
select unique order_detail_id from ns_shift_order_detail where shift_header_id in (
  select shift_header_id from ns_shift_detail where shift_date between rptDateFrom and rptDateTo
)
and order_detail_id in (
  select order_detail_id from ns_od_from union select order_detail_id from ns_od_to
);

select count(*) into numODs from orders;
select count(*) into numTransportsFrom from ns_od_from where order_detail_id in (select id from orders);
select count(*) into numTransportsTo from ns_od_to where order_detail_id in (select id from orders);
select count(*) into numPendings from ns_stock where order_detail_id in (select id from orders);
select count(*) into numFinals from ns_stock where reporting_order_detail_id in (
  select shift_order_detail_id from ns_shift_order_detail where order_detail_id in(select id from orders));

DBMS_OUTPUT.PUT_LINE(numODs+numTransportsFrom+numTransportsTo+numPendings+numFinals);

delete from orders;
insert into orders values ('ODs:', numODs);
insert into orders values ('TrIns:', numTransportsFrom);
insert into orders values ('TrOut:', numTransportsTo);
insert into orders values ('Pendings:', numPendings);
insert into orders values ('Finals:', numFinals);
insert into orders select 'Total:', sum(id) from orders;

END;
/

select * from orders;
drop table orders;
DECLARE PROCEDURE myProc (dt IN VARCHAR2) IS
     BEGIN
        DBMS_OUTPUT.PUT_LINE (dt || ' -> ' || ADD_MONTHS (dt, 1));
     END;
  BEGIN
     myProc ('30-JAN-99');
     myProc ('27-FEB-99');
  END;
