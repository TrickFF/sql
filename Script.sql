USE shop;
DROP table if exists tbl;
CREATE table tbl (
name char(10) default 'anonimus',
discription varchar(255)
);
INSERT into tbl values (
'Сергей', 'Новый пользователь'
);
INSERT into tbl values (
'Василий', 'Новый пользователь'
);
SELECT * FROM tbl;
