/* 
       MSSV: 1712162
	   HỌ và tên: Võ Quốc Thắng
	   Email: voquocthang1999@gmail.com
	   Ngày làm: 20/3/2019
     
*/
CREATE DATABASE PRACTICE_QLCB;
CREATE TABLE KHACHHANG (
         MAKH char(15) NOT NULL,
		 TEN varchar(15),
		 DCHI varchar(50),
		 DTHOAI char(12),
		 constraint khPK primary key (MAKH)

);

CREATE TABLE NHANVIEN (
        MANV char(15) NOT NULL,
		TEN varchar(15),
		DCHI varchar(20),
		DTHOAI char(12),
		LUONG decimal(10,2),
		LOAINV bit
		constraint nvPK primary key (MANV)
);



CREATE TABLE LOAIMB(
       HANGSX varchar(15) NOT NULL,
	   MALOAI char(15),
	   constraint lmbPK primary key (MALOAI)
);

CREATE TABLE KHANANG (
       MANV char(15) NOT NULL,
	   MALOAI char(15) NOT NULL,
	   constraint knPK primary key (MANV,MALOAI),
	   constraint FK_khanang_nhanvien foreign key (MANV) references NHANVIEN(MANV),
	   constraint FK_khanang_loaiMB foreign key (MALOAI) references LOAIMB(MALOAI)
);

CREATE TABLE MAYBAY (
       SOHIEU int NOT NULL,
	   MALOAI char(15) NOT NULL,
	   constraint mbPPK primary key (SOHIEU,MALOAI),
	   constraint FK_maybay_loaiMB foreign key (MALOAI) references LOAIMB(MALOAI)
);

CREATE TABLE CHUYENBAY (
       MACB char(4) NOT NULL,
	   SBDI char(3),
	   SBDEN char(3),
	   GIODI time,
	   GIODEN time,
	   constraint cbPK primary key (MACB)
);
    

SET DATEFORMAT mdy;

CREATE TABLE LICHBAY(
        NGAYDI date NOT NULL,
		MACB char(4) NOT NULL,
		SOHIEU int,
		MALOAI char(15),
		constraint lbPK primary key (NGAYDI,MACB),
		constraint FK_LB_CB foreign key (MACB) references CHUYENBAY(MACB),
		constraint FK_LB_MB foreign key (SOHIEU,MALOAI) references MAYBAY(SOHIEU,MALOAI)
);



CREATE TABLE PHANCONG (
         MANV char(15) NOT NULL,
		 NGAYDI date NOT NULL,
		 MACB char(4) NOT NULL,
		 constraint pbPK primary key (MANV,NGAYDI,MACB),
		 constraint FK_PC_LB foreign key (NGAYDI,MACB) references LICHBAY (NGAYDI,MACB),
		 constraint FK_PC_NV foreign key (MANV) references NHANVIEN(MANV)
);

CREATE TABLE DATCHO(
         MAKH char(15) NOT NULL,
		 NGAYDI date NOT NULL,
		 MACB char(4) NOT NULL,
		 constraint dcPK primary key (MAKH,NGAYDI,MACB),
		 constraint FK_DC_LB foreign key (NGAYDI,MACB) references LICHBAY(NGAYDI,MACB),
		 constraint FK_DC_KH foreign key (MAKH) references KHACHHANG(MAKH)
);

-- add constraint to make sure customer only choose the available fight

GO
CREATE FUNCTION isAvailable ( @ngaydi date , @macb char(4) )
RETURNS bit
AS 
BEGIN 
              if( EXISTS (    SELECT *  
			                FROM LICHBAY
							WHERE  NGAYDI = @ngaydi AND MACB = @macb)   ) return 1;
			 return 0;
END 

GO

--add constraint to make sure the pilot only can fly with the suited type of airplane

GO
CREATE FUNCTION isSuitable( @nv char(15), @ngaydi date, @macb char(4)) 
RETURNS bit 
AS 
BEGIN 
               if( 0 in (SELECT LOAINV
			               FROM NHANVIEN
						   WHERE MANV  = @nv) ) return 1;


               if (  EXISTS ( SELECT * 
			   FROM KHANANG AS A JOIN LICHBAY AS b ON A.MALOAI = B.MALOAI
			   WHERE (A.MANV = @nv) AND (B.NGAYDI = @ngaydi) AND (B.MACB = @macb) )  )return 1;
			   return 0;
END
GO

ALTER TABLE  DATCHO 
ADD constraint booking CHECK ( dbo.isAvailable(NGAYDI,MACB) = 1 );

ALTER TABLE PHANCONG
ADD constraint fitfight CHECK ( dbo.isSuitable(MANV,NGAYDI,MACB) = 1);


-- insert data of customers

INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0009','Nga','223 Nguyen Trai','89322320');

INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0101','Anh','567 Tran Phu','8826729');

INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0045','Thu','285 Le Loi','8932203');


INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0012','Ha','435 Quan Trung','8933232');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0238','Hung','456 Pasteur','9812101');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0397','Thanh','234 Le Van Si','895243');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0582','Mai','789 Nguyen Du',NULL);
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0934','Minh','678 Le Lai',NULL);
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0091','Hai','345 Hung Vuong','8893223');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0314','Phuong','395 Vo Van Tan','8232320');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0613','Vu','348 CMT8','8343232');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0586','Son','123 Bach Dang','8556223');
INSERT INTO KHACHHANG (MAKH,TEN,DCHI,DTHOAI) 
        VALUES ('0422','Tien','75 Nguyen Thong','8332222');


-- insert data of staff

INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1006','Chi','12/6 Nguyen Kiem','8120012',150000,0);

INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1005','Giao','65 Nguyen Thai Son','8324467',500000,0);
INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1001','Huong','8 Dien Bien Phu','8330733',500000,1);
INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1002','Phong','1 Ly THuong Kiet','8308117',450000,1);
INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1004','Phuong','351 Lac Long Quan','8308117',250000,0);
INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1003','Quang','78 Truong Dinh','8324461',350000,1);
INSERT INTO NHANVIEN (MANV,TEN,DCHI,DTHOAI,LUONG,LOAINV)
       VALUES ('1007','Tam','36 Nguyen Van Cu','8458188',500000,0);


-- insert data of types of airplane

INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Airbus','A310');

INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Airbus','A320');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Airbus','A330');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Airbus','A340');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Boeing','B727');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Boeing','B747');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('Boeing','B757');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('MD','DC10');
INSERT INTO LOAIMB (HANGSX,MALOAI)
      VALUES ('MD','DC9');

-- insert data of ability

INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1001','B727');



INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1001','B747');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1001','DC10');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1001','DC10');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1002','A320');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1002','A340');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1002','B757');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1002','DC9');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1003','A310');
INSERT INTO KHANANG (MANV,MALOAI)
       VALUES ('1003','DC9');

--insert data of airplane

INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (10,'B747');

INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (11,'B727');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (13,'B727');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (13,'B747');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (21,'DC10');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (21,'DC9');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (22,'B757');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (22,'DC9');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (23,'DC9');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (24,'DC9');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (70,'A310');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (80,'A310');
INSERT INTO MAYBAY (SOHIEU,MALOAI)
       VALUES (93,'B757');

--insert data of flight
	   
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('100','SLC','BOS','08:00','17:50');

INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('112','DCA','DEN','14:00','18:07');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('121','STL','SLC','07:00','09:13');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('122','STL','YYV','08:30','10:19');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('206','DFW','STL','09:00','11:40');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('330','JFK','YYV','16:00','18:53');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('334','ORD','MIA','12:00','14:14');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('335','MIA','ORD','15:00','17:14');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('336','ORD','MIA','18:00','20:14');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('337','MIA','ORD','20:30','23:53');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('394','DFW','MIA','18:00','20:14');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('395','MIA','DFW','21:00','23:43');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('449','CDG','DEN','10:00','19:29');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('930','YYV','DCA','13:00','16:10');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('931','DCA','YYV','17:00','18:10');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('932','DCA','YYV','18:00','19:10');
INSERT INTO CHUYENBAY (MACB,SBDI,SBDEN,GIODI,GIODEN)
       VALUES('991','BOS','ORD','17:00','18:22');


-- insert data of schedule

INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','100',80,'A310');

INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','112',21,'DC10');
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','206',22,'DC9')
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','334',10,'B747');
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','395',23,'DC9');
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','991',22,'B757')
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('11/1/2000','337',10,'B747');
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','100',11,'B727');

--wrong data here
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','112',11,'B727')


INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','206',13,'B727');


-- wrong data here
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','334',10,'B747');

--wrong data here
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','335',10,'B747')


--wrong data here
INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','337',24,'DC9');



INSERT INTO LICHBAY(NGAYDI,MACB,SOHIEU,MALOAI)
       VALUES ('10/31/2000','449',70,'A310');


-- insert data of assignment


INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1001','11/01/2000','100');

INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1001','10/31/2000','100');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1002','11/01/2000','100');

INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1002','10/31/2000','100');

INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1003','10/31/2000','100');

INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1003','10/31/2000','337');

INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1004','10/31/2000','100');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1004','10/31/2000','337');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1005','10/31/2000','337');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1006','11/01/2000','991');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1006','10/31/2000','337');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1007','11/01/2000','112');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1007','11/01/2000','991');
INSERT INTO PHANCONG(MANV,NGAYDI,MACB)
       VALUES ('1007','10/31/2000','206');


-- insert date of booking

INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0009','11/01/2000','100');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0009','10/31/2000','449');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0045','11/01/2000','991');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0012','10/31/2000','206');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0238','10/31/2000','334');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0582','11/01/2000','991');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0091','11/01/2000','100');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0314','10/31/2000','449');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0613','11/01/2000','100');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0586','11/01/2000','991');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0586','10/31/2000','100');
INSERT INTO DATCHO (MAKH,NGAYDI,MACB)
       VALUES ('0422','10/31/2000','449');


SELECT *
FROM PHaNCONG;

--Q1
select A.MANV,TEN,DCHI,DTHOAI
from (NHANVIEN  as A join PHANCONG as B on A.MANV= B.MANV ) join LICHBAY as C on (B.MACB = C.MACB and B.NGAYDI = C.NGAYDI)
where LOAINV=1 and MALOAI = 'B747';

--Q2
select MACB 
from CHUYENBAY 
where SBDI='DCA' and ( GIODI between '14:00' and'18:00')

--Q3
select TEN
from ( NHANVIEN as A join PHANCONG as B on A.MANV = B.MANV) join CHUYENBAY as C on B.MACB=C.MACB
where SBDI = 'SLC' and C.MACB='100'
--Q3
select TEN 
from NHANVIEN as A join PHANCONG as B on A.MANV = b.MANV
where B.MACB in (select MACB 
                  from CHUYENBAY 
				  where MACB='100' and SBDI='SLC')
--Q4
select distinct MALOAI,SOHIEU
from CHUYENBAY as A join LICHBAY as B on  A.MACB=B.MACB
where SBDI='MIA'

--Q5
select MACB,NgayDi,Ten,DCHI,DTHOAI
from DATCHO as A join KHACHHANG as B on A.MAKH=B.MAKH
order by MACB ,NGAYDI DESC

--Q6
select MACB,NGAYDI,TEN,DCHI,DTHOAI
from PHANCONG as A  join NHANVIEN as B on A.MANV=B.MANV
order by MACb,NGAYDI DESC

--Q7
select MACB,NGAYDI,TEN
from NHANVIEN as A  join PHANCONG as B on A.MANV=B.MANV
where LOAINV=1 and B.MACB in (select MACB
                              from CHUYENBAY 
							  where SBDEN='ORD')

--Q8
select A.MACB,A.NGAYDI,C.TEN
from    ( NHanVien as C  join PHANCONG as A on C.MANV = A.MANV) 
where  A.MANV='1001'


--Q9
select A.*,B.NGAYDI
from CHUYENBAY as A join LICHBAY as B on A.MACB=B.MACB
where SBDEN='DEN'
order by B.NGAYDI DESC,SBDI 


--Q10
select Ten,HANGSX,C.MALOAI
from ( KHANANG as A  join NHANVIEN  as B on  A.MANV=B.MANV) join LOAIMB as C  on  A.MALOAI=C.MALOAI

select *
from PHANCONG
set DaTEFormat dmy;
--Q11
select A.MANV,TEN
from NHANVIEN as A join PHANCONG as B on  A.MANV=B.MANV
where MACB='100' and NGAYDI='01-11-2000'and A.LOAINV=1

set DaTEFormat dmy;
--Q12
select B.MACB,A.MANV,A.TEN
from NHANVIEN as A join PHANCONG as B on A.MANV = B.MANV
where B.NGAYDI='2000/10/31' and B.MACB in (select MACB 
                  from CHUYENBAY 
				  where SBDI='MIA' and GIODI='20:30')

--Q13
select LB.MACB,LB.SOHIEU,LB.MALOAI,LMB.HANGSX
from ( PHANCONG as PC join LICHBAY as LB on PC.MACB=LB.MACB) join LOAIMB as LMB on LB.MALOAI=LMB.MALOAI
where PC.MANV in (select MANV 
                  from NHANVIEN
				   where TEN like '%Quang')
--Q14
select TEN
from NHANVIEN as NV left join PHANCONG as PC on NV.MANV=PC.MANV
where MACB is NULL and NV.LOAINV=1

--Q15
select distinct KH.TEN 
from (KHACHHANG as KH join DATCHO as DC on KH.MAKH=DC.MAKH) join LICHBAY as LB on(  LB.MACB=DC.MACB and LB.NGAYDI=DC.NGAYDI)
where LB.MALOAI in (select MALOAI 
                   from LOAIMB
				   where HANGSX='Boeing')

-- Q16

(select MACB 
from LICHBAY as LB
where LB.SOHIEU='10' and LB.MALOAI='B747')
except 
( select MACB
from LICHBAY as LB 
where LB.SOHIEU!='10' or LB.MALOAI!='B747'
)


--Q17
select count(*),SBDEN
from CHUYENBAY
group by SBDEN
order by SBDEN

--Q18
select count(*),SBDI
from CHUYENBAY
group by SBDI
order by SBDI

--Q19
select SBDi,LB.NGAYDI,count(LB.NGAYDI) 
from CHUYENBAY as CB join LICHBAY as LB on CB.MACB=LB.MACB
group by SBDI,LB.NGAYDI
--Q20
select SBDEN,LB.NGAYDI,count(LB.NGAYDI) as "SOLUONG"
from CHUYENBAY as CB join LICHBAY as LB on CB.MACB=LB.MACB
group by SBDEN,LB.NGAYDI

--Q21
select LB.MACB,LB.NGAYDI,count(*)
from ( LICHBAY as LB join PHANCONG as PC on LB.MACB=PC.MACB ) join NHANVIEN as NV on NV.MANV=PC.MANV
where NV.LOAINV=1
group by LB.NGAYDI,LB.MACB

--Q22
select count(*) as "SOLUONG"
from CHUYENBAY as CB join LICHBAY as LB on CB.MACB=LB.MACB
where LB.NGAYDI ='2000-11-01' and SBDi='MIA'
group by SBDI
having SBDi='MIA'

select * 
from PHANCONG
order by MACB
--Q23
select CB.MACB,PC.NGAYDI,count(PC.MANV)
from CHUYENBAY as CB left join PHANCONG as PC on CB.MACB = PC.MACB
group by CB.MACB,PC.NGAYDI,PC.NGAYDI
order by count(PC.MANV) DESC

--Q24
select CB.MACB,DC.NGAYDI,count(DC.MAKH) as "SOLUONG"
from CHUYENBAY as CB left join DATCHO as DC on CB.MACB=DC.MACB
group by CB.MACB,DC.NGAYDI
order by count(DC.MAKH) desc

--Q25
select CB.MACB,PC.NGAYDI,sum(NV.LUONG)
from  CHUYENBAY as CB left join ( PHANCONG as PC  join NHANVIEN as NV on NV.MANV=PC.MANV)on CB.MACB=PC.MACB
group by CB.MACB,PC.NGAYDI
order by sum(NV.LUONG)

--Q26
select AVG(Luong) as "LUONG TRUNG BINH NHAN VIEN"
from NHANVIEN
where LOAINV!=1


--Q27
select AVG(Luong) as "LUONG TRUNG BINH NHAN VIEN"
from NHANVIEN
where LOAINV=1


--Q28
select distinct LMB.MALOAI,count( CB.SBDEN)
from LOAIMB as LMB left join (CHUYENBAY as CB join LICHBAY as LB on CB.MACB=LB.MACB) on  LMB.MALOAI=LB.MALOAI
group by LMB.MALOAI,CB.SBDEN
having CB.SBDEN='ORD' or CB.SBDEN is NULL

--Q29
select SBDI,count(*)
from CHUYENBAY
where GIODI between '10:00' and '22:00'
group by SBDI
having count(*) > 2


--Q30
select NV.TEN,count(NV.MANV)
from NHANVIEN as NV join PHANCONG as PC on NV.MANV=PC.MANV
where NV.LOAINV=1
group by PC.NGAYDI,NV.MANV,NV.TEN
Having count(NV.MANV) >=2

select *
from DATCHO

--Q31
select CB.MACB,NGAYDI,Count(MAKH)
from CHUYENBAY as CB join DATCHO as DC on CB.MACB=DC.MACB
group by CB.MACB,NGAYDI
having count(MAKH) <3 

--Q32

select SOHIEU,MALOAI,count(*)
from PHANCONG as PC join LICHBAY as LB on (PC.MACB=LB.MACB and PC.NGAYDI=LB.NGAYDI)
where PC.MANV='1001'
group by SOHIEU,MALOAI
having count(*) >2

--Q33
select HANGSX,count(MALOAI)
from LOAIMB
group by HANGSX

--Q34
select LB.SOHIEU,LB.MALOAI,LMB.HANGSX,count(*)
from  LICHBAY as LB join LOAIMB as LMB on LMB.MALOAI=LB.MALOAI
group by LB.SOHIEU,LB.MALOAI,LMB.HANGSX
having count(*) >= ALL( select count(*)
                        from LICHBAY as LB1
                        group by LB1.SOHIEU,LB1.MALOAI)
--Q35
select NV.TEN
from PHANCONG as PC join NHANVIEN as NV on PC.MANV=NV.MANV
group by PC.MANV,NV.TEN
having count(PC.MANV) >= ALL(select count(*) 
                              from PHANCONG as PC1
							  group by PC1.MANV)

--Q36
select NV.TEN,NV.DCHI,NV.DTHOAI
from PHANCONG as PC join NHANVIEN as NV on PC.MANV=NV.MANV
where NV.LOAINV=1
group by PC.MANV,NV.TEN,NV.DCHI,NV.DTHOAI
having count(PC.MANV) >= ALL(select count(PC1.MANV) 
                             from PHANCONG as PC1 join NHANVIEN as NV1 on PC1.MANV=NV1.MANV
							 where NV1.LOAINV=1
							 group by PC1.MANV)


--Q37
select CB.SBDEN,count(*)
from CHUYENBAY as CB
group by CB.SBDEN
having count(*)  <= ALL(select count(*)
                        from CHUYENBAY as CB1
						group by CB1.SBDEN ) 

--Q38
select CB.SBDI,count(*)
from CHUYENBAY as CB 
group by CB.SBDI
having count(*) >= ALL (select count(*) 
                        from CHUYENBAY as CB1
						group by CB1.SBDI)

--Q39
select KH.TEN,KH.DCHI,KH.DTHOAI,count(*)
from DATCHO as DC join KHACHHANG as KH on DC.MAKH=KH.MAKH
group by DC.MAKH,KH.TEN,KH.DCHI,KH.DTHOAI
having  count(*) >= All (select count(*) 
                          from DATCHO as DC1
						  group by DC1.MAKH)

select * 
from KHANANG

--Q40
select NV.MANV,NV.TEN,NV.LUONG
from KHANANG as KN join NHANVIEN as NV on KN.MANV=NV.MANV
group by KN.MANV,NV.MANV,NV.TEN,NV.LUONG
having count(*) >= ALL( select count(*)
                        from KHANANG as KN1 
						group by KN1.MANV)

--Q41
select NV.MANV,NV.TEN,NV.LUONG
from NHANVIEN as NV 
where Nv.LUONG >= All(select NV1.LUONG 
                       from NHANVIEN as NV1)

--Q42

select distinct Nv.ten,Nv.DCHI
from PHANCONG as PC join NHANVIEN as NV on PC.MANV=NV.MANV
where Nv.LUONG in (select max(Nv1.Luong)
                  from PHANCONG as PC1 join NHANVIEN as NV1 on PC1.MANV=NV1.MANV
				  group by PC1.MACB,PC1.NGAYDI
                  )

--Q43
select CB.MACB,CB.GIODI,Cb.GIODEN
from CHUYENBAY as CB
where Cb.GIODI <= ALL(select CB1.GIODI
                      from CHUYENBAY as CB1)
--Q44
select CB.MACB,DateDiff(MINUTE,GIODI,GIODEN) as "MINUTES"
from CHUYENBAY as Cb 
where DateDiff(minute,GIODI,GIODEN ) >=ALL( select DATEDIFF(MINUTE,CB1.GIODI,Cb1.GIODEN)
	                                         from CHUYENBAY as CB1)

--Q45
select CB.MACB,DATEDIFF(minute,CB.GIODI,CB.GIODEN)
from CHUYENBAY as CB
where DATEDIFF(minute,CB.GioDi,CB.GioDen) <= ALL(select DATEDIFF(minute,CB1.GIODI,CB1.GIODEN)
                                                  from CHUYENBAY as CB1)
--Q46
-- didn't understand the problem

--Q47
select PC.MACB,PC.NGAYDI,count(PC.MANV)  
from PHANCONG as PC 
where PC.MACB in (select DC.MACB
                  from DATCHO as DC 
                  group by DC.MACB,DC.NGAYDI
                   having count(Dc.MAKH) > 3
				  )  
	 and  PC.NGAYDI in (select DC.NGAYDI
                  from DATCHO as DC 
                  group by DC.MACB,DC.NGAYDI
                   having count(Dc.MAKH) > 3
				  )  
group by Pc.NGAYDI,PC.MACB

--Q48
select  Nv.LOAINV,count(*)
from NHANVIEN  as Nv
where Nv.LUONG > 600000
group by Nv.LOAINV

--Q49

select count(DC.MAKH)
from DATCHO as DC
where Dc.MACB in (select Pc.MACB
                  from PHANCONG as PC 
				  group by PC.MACB,PC.NGAYDI
				  having count(Pc.MANV) >3)
	  and Dc.NGAYDI in (select Pc.NGAYDI
                  from PHANCONG as PC 
				  group by PC.MACB,PC.NGAYDI
				  having count(Pc.MANV) >3)
group by DC.MACB,DC.NGAYDI


--Q50
select LB.MALOAI,count(*) as "NUMBER"
from LICHBAY as LB
where LB.MALOAI in (
                      select MB.MALOAI
                      from MAYBAY as MB 
                      group by MALOAI
                      having count(MB.SOHIEU) >1
                    )
group by LB.MALOAI

--Q51 

--Q52


select NV.MANV,NV.TEN
from  KHANANG as KN join NHANVIEN as NV on KN.MANV=NV.MANV
where NOT EXISTS ( 
                  ( select LMB.MALOAI
                     From LOAIMB  as LMB
					 where HANGSX='MD'
				   )
				   except
				   (
				     select KN1.MALOAI
					 from KHANANG as KN1
					 where KN.MALOAI=KN1.MALOAI 
				   )
                )

--Q53
select Nv.TEN
from NHANVIEN as NV
where Nv.LOAINV!=1 and  not exists (
                  (
				  select MANV
                  from PHANCONG
				  where MACB='206'
				  )
				  except
				  (
				  select MANV
				  from NHANVIEN as NV1
				  where NV.MANV = NV1.MANV
				  )
				 )
--Q54
select distinct LB.NGAYDI
from LICHBAY as LB 
where NOT EXISTS (
                    (select MALOAI
					from LOAIMB
					where HANGSX='Boeing')
					except 
					( select MALOAI 
					  from LICHBAY as LB1
					  where LB.NGAYDI=LB1.NGAYDI)
                 )

--Q55
select distinct LMB.MALOAI 
from LOAIMB LMB
where LMB.HANGSX='Boeing' and NOT EXISTS (
                     (
					  select LB.NGAYDI
					  from LICHBAY as LB 
					  ) 
					  except
					  (
					   select LB1.NGAYDI
					   from LICHBAY as LB1
					   where LMB.MALOAI=LB1.MALOAI
					  )
                 )

--Q56

select Kh.MAKH,Kh.TEN
from KHACHHANG as KH
where NOT EXISTS (
                   (
				     select NGAYDI
					 from DATCHO
					 where NGAYDI between '2000-10-31' and '2000-11-01'
				   )
				   except 
				   (
				       select NGAYDI
					   from DATCHO as DC 
					   where DC.MAKH=KH.MAKH
				   )
                 )


--Q57
select distinct NHANVIEN.MANV,NHANVIEN.TEN
from KHANANG as KN  join NHANVIEN on KN.MANV = NHANVIEN.MANV
where EXISTS (
                (select MALOAI
				 from LOAIMB 
				 where HANGSX='Airbus')
				 except
				 (select MALOAI 
				  from KHANANG as KN1 
				  where KN.MALOAI = KN1.MALOAI)
             )
--Q58
select distinct Cb.SBDI
from CHUYENBAY as CB
where not Exists (
                       (
					       select LMB.MALOAI
						   from LOAIMB as LMB 
						   where LMB.HANGSX='Boeing'
					   )
					   except
					   (
					        select LB.MALOAI
							from LICHBAY as LB join CHUYENBAY as CB1 on LB.MACB=CB1.MACB
							where CB1.SBDI=CB.SBDI
					   )
                 )