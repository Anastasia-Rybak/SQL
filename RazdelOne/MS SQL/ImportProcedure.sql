SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Import
	@datasource nvarchar(4000)
AS
BEGIN
    exec sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',N'AllowInProcess',1
	exec sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',N'DynamicParameters',1
	exec sp_addlinkedserver
		@server = 'ExcelServer',
		@srvproduct = 'Excel',
		@provider = 'Microsoft.ACE.OLEDB.12.0',
		@datasrc = @datasource,
		@provstr = 'Excel 12.0;IMEX=1;HDR=YES'
	SET IDENTITY_INSERT dbo.authors ON;
	insert into dbo.authors (a_id, a_name) select * from openquery (ExcelServer,'Select * from [authors$]')
	SET IDENTITY_INSERT dbo.authors OFF;
	SET IDENTITY_INSERT dbo.books ON;
	insert into dbo.books (b_id, b_name, b_year, b_quantity) select * from openquery (ExcelServer,'Select * from [books$]')
	SET IDENTITY_INSERT dbo.books OFF;
	SET IDENTITY_INSERT dbo.genres ON;
	insert into dbo.genres (g_id, g_name) select * from openquery (ExcelServer,'Select * from [genres$]')
	SET IDENTITY_INSERT dbo.genres OFF;
	SET IDENTITY_INSERT dbo.subscribes ON;
	insert into dbo.subscribes(s_id, s_name) select * from openquery (ExcelServer,'Select * from [subscribes$]')
	SET IDENTITY_INSERT dbo.subscribes OFF;
	insert into dbo.m2m_books_authors(b_id, a_id) select * from openquery (ExcelServer,'Select * from [m2m_books_authors$]')
	insert into dbo.m2m_books_genres(b_id, g_id) select * from openquery (ExcelServer,'Select * from [m2m_books_genres$]')
	insert into dbo.subscriptions(sb_id, sb_subscriber, sb_book, sb_start, sb_finish, sb_is_active) select * from openquery (ExcelServer,'Select * from [subscriptions$]')
	exec sp_configure 'show advanced options', 1;
	reconfigure
	exec sp_configure 'Ad Hoc Distributed Queries', 1;
END
GO
