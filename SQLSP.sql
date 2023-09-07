--BİR TABLODAKİ KOLONU DİĞER TABLODAKİ KOLONA TANIMLAMA--
---------------------------------------------------------------------------------------------------------
select * from tblKişiselBilgiler
select * from tblEğitimKayıtları

--foreign key bir tablonun bir kolonuna girecek değerlerin başka bir tablonun bir kolonundaki
--değerlerin dışında değer almasını önler.
--değerlerin alındığı diğer tablonun o kolonu ise Primary Key yada Unique Key olmalıdır.

--delete tblEğitimKayıtları
--where EğitimAdı=3


--tblEğitimKayıtları tablosunun ÖgrNo kolonunu tblKişiselBilgiler tablosunun ÖgrNo kolonuna FK(foreign key) ile bağlayalım.
alter table tblEğitimKayıtları
add constraint fk_tblEğitimKayıtları_ÖgrNo foreign key(ÖgrNo)
references tblKişiselBilgiler(ÖgrNo)
------------------------------------------------------------------------------------------------------------------------------
select * from tblKişiselBilgiler
select * from tblEğitimKayıtları


--JOİNLER--
--------------------------------------------------------------------------------------------------
--Hangi öğrenci,adı,telefonu,TcNo,hangi eğitimi,kayıt türü ve mezuniyet durumu ile listelesin.
--bu sorguda iki farklı tablodan veri çekme var.
--iki ya da daha fazla sayıda tablodan veri çekmede *join* kullanılır
select AdıSoyadı,TcNo,Telefon,EğitimAdı,KayıtTürü,MezuniyetDurumu from tblKişiselBilgiler KB
join tblEğitimKayıtları EK
on 
KB.ÖgrNo=EK.ÖgrNo
--left join
select AdıSoyadı,TcNo,Telefon,EğitimAdı,KayıtTürü,MezuniyetDurumu from tblKişiselBilgiler KB
left join tblEğitimKayıtları EK
on 
KB.ÖgrNo=EK.ÖgrNo
--right join
select AdıSoyadı,TcNo,Telefon,EğitimAdı,KayıtTürü,MezuniyetDurumu from tblKişiselBilgiler KB
right join tblEğitimKayıtları EK
on 
KB.ÖgrNo=EK.ÖgrNo




select AdıSoyadı,TcNo,Telefon,EğitimAdı,

case KayıtTürü
when 1 then 'KesinKayıt'
when 0 then 'ÖnKayıt'
end as KayıtDurumu
,MezuniyetDurumu from tblKişiselBilgiler KB
inner join tblEğitimKayıtları EK
on 
KB.ÖgrNo=EK.ÖgrNo
---------------------------------------------------------------------------
select * from tblKişiselBilgiler
select * from tblEğitimKayıtları
select * from tblÖdemePlanları
-------------------------------------------
--EğitimKayıtları tablosu ile ÖdemePlanları tablosundaki EğitimId kolonunu birbirine tanımladık.
---------------------------------------------------------------------------------------------------
alter table tblÖdemePlanları
add constraint fk_tblÖdemePlanları_tblEğitimKayıtları foreign key(EğitimId)
references tblEğitimKayıtları(EğitimId)
---------------------------------------------------------------------------------

--hangi öğrenci,hangi eğitime,ne kadar ücrete,indirim oranı,Peşinat,ödenecek tutar,ödeme biçimi,taksit sayısı bilgileriyle listeleyelim
--bu sorgu 3 farklı tablodan veri çekmektedir
--dolayısıyla JOİN yapmak gerekir.
-----------------------------------------------------------------------------------------------------------------
select AdıSoyadı,EğitimAdı,Ücret,İndirimOranı,Peşinat,ÖdenecekTutar,
case ÖdemeBiçimi
when 1 then 'Peşin'
when 0 then 'Taksitli'
end
as ÖdemeBiçimi
,
TaksitSayısı from tblKişiselBilgiler KB
join tblEğitimKayıtları EK
on
KB.ÖgrNo=EK.ÖgrNo
join tblÖdemePlanları ÖP
on
EK.EğitimId=ÖP.EğitimId
---------------------------------------------------
select * from tblKişiselBilgiler
select * from tblEğitimKayıtları
select * from tblÖdemePlanları
select * from tblTaksitler


delete tblEğitimKayıtları 
where EğitimId=1
--CASCADE kullan
-----------------------------------------------------------
delete tblKişiselBilgiler
where TcNo='1111'


--SQL de basit program yazma-----------------------------------------------------------------------
--değişkenler
--değişken tanımlama
declare @Tur int
declare @Ad varchar(20)
declare @Cinsiyet bit
declare @Maaş money
declare @dTarihi date
--değişkene değer atama
set @Tur=1
set @Ad='Ali'
set @Cinsiyet=1
set @Maaş=50000
set @dTarihi='2000-01-01'

--if yapısı
if(@Maaş>11500)
begin
print'Asgari ücretin üstüne'
end

else if(@Maaş<11500)
begin
print'Asgari ücretin altında'
end

else
begin
print'Asgari ücretle çalışan'
end

--while döngüsü
declare @Tur1 int
set @Tur1=1
while(@Tur1<=10)
begin
--cast ve convert fonksiyonları ile SQL de tür dönüşümü yapabiliriz.
print cast(@Tur1 as varchar(4))+'. SQL den herkese selamlar...'--free SQL
print convert(varchar(4),@Tur1)+'. Hello from SQL...' --convert Microsoft SQL demek
set @Tur1=@Tur1+1
end

-------------ÇOK ÖNEMLİ-----------
---SQL de procedure(proc) yazmak.



create proc spÖğrencilerEğitimlerÜcretler
as
begin

select AdıSoyadı,EğitimAdı,Ücret,İndirimOranı,Peşinat,ÖdenecekTutar,
case ÖdemeBiçimi
when 1 then 'Peşin'
when 0 then 'Taksitli'
end
as ÖdemeBiçimi
,
TaksitSayısı from tblKişiselBilgiler KB
join tblEğitimKayıtları EK
on
KB.ÖgrNo=EK.ÖgrNo
join tblÖdemePlanları ÖP
on
EK.EğitimId=ÖP.EğitimId

end

exec spÖğrencilerEğitimlerÜcretler

select * from tblÖdemePlanları

create proc spCinsiyeteGöreÖğrenciler
as
begin

select * from tblKişiselBilgiler
where Cinsiyet=1
end

exec spCinsiyeteGöreÖğrenciler

alter proc spCinsiyeteGöreÖğrenciler1
@Cins bit
as
begin

select * from tblKişiselBilgiler
where Cinsiyet=@Cins
end

exec spCinsiyeteGöreÖğrenciler1 0


select * from tblKişiselBilgiler
insert into tblKişiselBilgiler
values('NamıkKemal','6666','0534333','nmk@namık.com','1919-01-01',1,'LiseTerk','sadasd','asdsa','2023-05-05','sadasd')

alter proc spÖğrenciKaydet
@AdıSoyadı varchar(40),
@TcNo char(11),
@Telefon varchar(15),
@Mail varchar(50),
@DoğumTarihi date,
@Cinsiyet bit,
@EğitimDüzeyi varchar(15),
@Hakkında varchar(300),
@Adres varchar(150),
@KayıtTarihi date,
@Resim varchar(max)
as 
begin
insert into tblKişiselBilgiler
values(
@AdıSoyadı ,
@TcNo ,
@Telefon ,
@Mail ,
@DoğumTarihi ,
@Cinsiyet ,
@EğitimDüzeyi ,
@Hakkında ,
@Adres ,
@KayıtTarihi ,
@Resim)

end

exec spÖğrenciKaydet 'NamıkKemal','6666','0534333','nmk@namık.com','1919-01-01',1,'LiseTerk','sadasd','asdsa','2023-05-05','sadasd'







