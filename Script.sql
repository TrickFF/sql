USE shop;
DROP table if exists tbl;
CREATE table tbl (
name char(10) default 'anonimus',
discription varchar(255)
);
INSERT into tbl values (
'������', '����� ������������'
);
INSERT into tbl values (
'�������', '����� ������������'
);
SELECT * FROM tbl;
