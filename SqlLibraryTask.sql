create database LibraryDB
use LibraryDB

create table Author
(
Id int primary key identity,
Name nvarchar(50) not null,
Surname nvarchar(50) not null
)
create table Books
(
Id int primary key identity,
Name nvarchar(100) not null check (len(Name) >2),
AuthorId int  foreign key references Author(Id),
PageCount int not null check(PageCount>10)
)

-- HOCAM DATALARI CHATGPT-YE DOLDURTMUSAM :)

-- Insert data into Author table
INSERT INTO Author (Name, Surname) VALUES
('J.K.', 'Rowling'),
('George', 'Orwell'),
('J.R.R.', 'Tolkien'),
('Agatha', 'Christie'),
('Mark', 'Twain'),
('Jane', 'Austen'),
('Charles', 'Dickens'),
('Fyodor', 'Dostoevsky'),
('Leo', 'Tolstoy'),
('Ernest', 'Hemingway');

-- Insert data into Books table
INSERT INTO Books (Name, AuthorId, PageCount) VALUES
('Harry Potter and the Philosophers Stone', 1, 223),
('1984', 2, 328),
('Animal Farm', 2, 112),
('The Hobbit', 3, 310),
('The Lord of the Rings', 3, 1178),
('Murder on the Orient Express', 4, 256),
('The Adventures of Tom Sawyer', 5, 274),
('Pride and Prejudice', 6, 279),
('A Tale of Two Cities', 7, 341),
('Crime and Punishment', 8, 671),
('War and Peace', 9, 1225),
('The Old Man and the Sea', 10, 127);


-- Id,Name,PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin

Create view Show_Books_Infos
as
select b.Id , b.Name , b.PageCount,a.Name+' ' +a.Surname as Fullname from  Books as b
join Author as a
on b.AuthorId = a.Id

select * from Show_Books_Infos

/* 
Gonderilmis axtaris deyirene gore hemin axtaris deyeri name ve ya authorFullNamelerinde olan Book-lari
Id,Name,PageCount,AuthorFullName columnlari seklinde gostern procedure yazin
*/

Create procedure Show_Books_By_Author(@SearchKeyword Nvarchar(50))
as
select b.Id , b.Name , b.PageCount,a.Name+' ' +a.Surname as Fullname from  Books as b
join Author as a
on b.AuthorId = a.Id
Where 
a.Name like '%'+@SearchKeyword + '%'
or
a.Name+' ' +a.Surname like '%'+@SearchKeyword+'%'

exec Show_Books_By_Author 'George'


--Authors tableinin insert,update ve deleti ucun (her biri ucun ayrica) procedure yaradin
--Insert
Create procedure InsertAuthor(@Name nvarchar(50),@SurName nvarchar(50))
as
insert into Author(Name,Surname)
values(@Name,@SurName)

exec InsertAuthor  'Nietzsche','Friedrich'
select * from Author

--update
Create procedure UpdateAuthor(@Id int ,@Name nvarchar(50),@Surname nvarchar(50))
as
update Author
set Name = @Name, Surname =@Surname
where Id = @Id

exec InsertAuthor 'Sigmuntt' , 'Freud'
exec UpdateAuthor 12,'Sigmund' , 'Freud'
select * from Author

--delete
create procedure DeleteAuthor(@Id int)
as
delete from Author
where @Id = Id

exec InsertAuthor 'Sigmuntt' , 'Freud'
exec DeleteAuthor 13
select * from Author
	



/*Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz 
Id-author id-si, 
FullName - Name ve Surname birlesmesi,
BooksCount - Hemin authorun elaqeli oldugu kitablarin sayi,
MaxPageCount - hemin authorun elaqeli oldugu kitablarin icerisindeki max pagecount deyeri*/

Create view Show_FullInfo_Authors
as
select a.Id as 'Author Id', a.Name + ' '+ a.Surname as FullName, Count(*) as BooksCount , Max(b.PageCount) as MaxPageCount  from Author as a 
join Books as b
on a.Id = b.AuthorId
group by a.Id , a.Name, a.Surname
select * from Show_FullInfo_Authors