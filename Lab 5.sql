﻿--BÀI 1
--In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của bạn.
create procedure lab5_bai1_a @name nvarchar(20)
as
	begin
		print 'xin chào: ' + @name
	end
exec lab5_bai1_a 'Nhật Hào'
go

--Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
create procedure lab5_bai1_b @so1 int, @so2 int
as
	begin
		declare @tong int = 0;
		set @tong = @so1 + @so2 
		print 'tong: ' + cast(@tong as varchar(10))
	end
exec lab5_bai1_b 19,2
go

--Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
create proc lab5_bai1_c @l int
as
	begin
		declare @tong int = 0, @i int = 0;
		while @i < @l
			begin
				set @tong = @tong + @i
				set @i = @i + 2
			end
		print 'Tổng các số chẵn: ' + cast(@tong as varchar(10))
	end
exec lab5_bai1_c 8
go

--Nhập vào 2 số. In ra ước chung lớn nhất của chúng theo gợi ý dưới đây:
create proc lab5_bai1_d @a int, @b int
as
	begin
		while (@a != @b)
			begin
				if(@a > @b)
					set @a = @a -@b
				else
					set @b = @b - @a
			end
			return @a
	end
declare @l int
exec @l = lab5_bai1_d 23,8
print @l
go

BÀI 2
--Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
create proc lab5_bai2_a @MaNV varchar(20)
as
	begin
		select * from NHANVIEN where MANV = @MaNV
	end
exec lab5_bai2_a '196'
go

--Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
select count(MANV), MADA, TENPHG from NHANVIEN
inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
where MADA = 2
group by TENPHG,MADA

alter proc lab5_bai2_b @manv int
as
begin
		select count(MANV) as 'so luong', MADA, TENPHG from NHANVIEN
		inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
		inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
		where MADA = @manv
		group by TENPHG,MADA
end
exec lab5_bai2_b 19
go

--Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
select count(MANV)as 'so luong', MADA, TENPHG from NHANVIEN
inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
where MADA = 2 and DDIEM_DA = 'Quảng Bình'
group by TENPHG,MADA
go

--Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là @Trphg và các nhân viên này không có thân nhân.
select HONV, TENNV, TENPHG, NHANVIEN.MANV, THANNHAN.*
from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
left outer join THANNHAN on THANNHAN.MA_NVIEN = NHANVIEN.MANV
where THANNHAN.MA_NVIEN is null and TRPHG = '1902'

create proc lab5_bai2_d @MaTP varchar(10)
as
begin
	select HONV, TENNV, TENPHG, NHANVIEN.MANV, THANNHAN.*
	from NHANVIEN
	inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
	left outer join THANNHAN on THANNHAN.MA_NVIEN = NHANVIEN.MANV
	where THANNHAN.MA_NVIEN is null and TRPHG = @MaTP
end

exec lab5_bai2_d '1902'
go

--Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có mã @Mapb hay không
if exists (select * from NHANVIEN where MANV = '2308' and PHG = '22')
print 'Nhan vien co trong phong ban'
else 
print 'Nhan vien khong co trong phong ban'

create proc lab5_bai2_e @MaNV varchar(10), @MaPB varchar(10)
as
begin
	if exists(select * from NHANVIEN where MANV = '2308' and PHG=@MaPB)
	print 'Nhan vien:' + @MaNV +'co trong phong ban: '+@MaPB
else 
	print 'Nhan vien: '+ @MaNV+'khong co trong phong ban: '+@MaPB
end

exec lab5_bai2_e '2308','22'
--Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
insert into PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
values ('7','CNTT','008','2002-07-28')

create proc lab5_bai3_a
	@MaPB int, @TenPB nvarchar(20),
	@MaTP varchar(10), @NgayNhanChuc date
as
	begin
		if(exists(select * from PHONGBAN where MaPHG=@MaPB))
			print'Them that bai'
		else 
			begin
				insert into PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
				values (@MaPB,@TenPB,@MaTP,@NgayNhanChuc)
				print 'Them thanh cong'
		end
end

exec lab5_bai3_a '7','CNTT','008','2002-07-28'

--Cập nhật phòng ban có tên CNTT thành phòng IT.
create proc lab5_bai3_b
	@MaPB int, @TenPB nvarchar(20),
	@MaTP varchar(10), @NgayNhanChuc date
as
	begin
		if(exists(select * from PHONGBAN where MaPHG=@MaPB))
			update PHONGBAN set TENPHG =@TenPB, TRPHG=@MaTP,NG_NHANCHUC =@NgayNhanChuc
			where MAPHG = @MaPB
		else 
			begin
				insert into PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
				values (@MaPB,@TenPB,@MaTP,@NgayNhanChuc)
				print 'Them thanh cong'
		end
end

exec lab5_bai3_b '7','CNTT','008','2002-07-28'

--Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu
select HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG from NHANVIEN
insert into NHANVIEN(HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
values('Cao', 'Nhật', 'Hào', '0219', '2002-02-19', 'Quảng Bình', 'Nam','275000', '2308', '12')

create proc lab5_bai3_c
@HONV varchar(10), @TENLOT varchar(10), @TENNV varchar(10),
@MANV varchar(10), @NGSINH date, @DCHI varchar(50), @PHAI varchar(10),
@LUONG float, @MA_NQL varchar(10) = null, @PHG int
as
begin
	declare @age int
	set @age = YEAR(GETDATE()) - YEAR(@NGSINH)
	if @PHG = (select MaPHG from PHONGBAN where TENPHG ='CNTT')
		begin
			if @LUONG < 25000
				set @MA_NQL = '009'
			else set @MA_NQL= '005'

			if(@PHAI = 'Nam' and (@age >= 18 and @age <= 65))
				or (@PHAI = N'Nữ' and (@age >= 18 and @age <= 60))
				begin
					insert into NHANVIEN(HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
					values(@HONV, @TENLOT, @TENNV, @MANV, @NGSINH, @DCHI, @PHAI, @LUONG, @MA_NQL, @PHG)
				end
			else
				print 'khong thuoc do tuoi lao dong'
		end
	else
		print 'khong phai phong CNTT'
end
exec lab5_bai3_c 'Cao', 'Nhật', 'Hào', '0219', '2002-02-19', 'Quảng Bình', 'Nam','275000', '2308', '12'
exec lab5_bai3_c 'Huỳnh', 'Thiên', 'Long', '1123', '2000-12-12', 'TP HCM', 'Nam','234000', '1100', '9'
exec lab5_bai3_c 'Lê', 'Ngọc', 'My', '1454', '1998-08-10', 'Hà Nội', 'Nữ','332000', '3360', '10'
