IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_m2m_books_authors_authors]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1) 
ALTER TABLE [m2m_books_authors] DROP CONSTRAINT [FK_m2m_books_authors_authors]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_m2m_books_authors_books]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1) 
ALTER TABLE [m2m_books_authors] DROP CONSTRAINT [FK_m2m_books_authors_books]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_m2m_books_genres_books]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1) 
ALTER TABLE [m2m_books_genres] DROP CONSTRAINT [FK_m2m_books_genres_books]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_m2m_books_genres_genres]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1) 
ALTER TABLE [m2m_books_genres] DROP CONSTRAINT [FK_m2m_books_genres_genres]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_subscriptions_books]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1) 
ALTER TABLE [subscriptions] DROP CONSTRAINT [FK_subscriptions_books]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_subscriptions_subscribes]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1) 
ALTER TABLE [subscriptions] DROP CONSTRAINT [FK_subscriptions_subscribes]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[authors]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [authors]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[books]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [books]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[genres]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [genres]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[m2m_books_authors]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [m2m_books_authors]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[m2m_books_genres]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [m2m_books_genres]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[subscribes]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [subscribes]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[subscriptions]') AND OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [subscriptions]
;

CREATE TABLE [authors]
(
	[a_id] int NOT NULL IDENTITY (1, 1),
	[a_name] nvarchar(150)
)
;

CREATE TABLE [books]
(
	[b_id] int NOT NULL IDENTITY (1, 1),
	[b_name] nvarchar(150),
	[b_year] smallint,
	[b_quantity] smallint
)
;

CREATE TABLE [genres]
(
	[g_id] int NOT NULL IDENTITY (1, 1),
	[g_name] nvarchar(150)
)
;

CREATE TABLE [m2m_books_authors]
(
	[b_id] int NOT NULL,
	[a_id] int NOT NULL
)
;

CREATE TABLE [m2m_books_genres]
(
	[b_id] int NOT NULL,
	[g_id] int NOT NULL
)
;

CREATE TABLE [subscribes]
(
	[s_id] int NOT NULL IDENTITY (1, 1),
	[s_name] nvarchar(150)
)
;

CREATE TABLE [subscriptions]
(
	[sb_id] int NOT NULL,
	[sb_subscriber] int,
	[sb_book] int,
	[sb_start] date,
	[sb_finish] date,
	[sb_is_active] char(1)
)
;

ALTER TABLE [authors] 
 ADD CONSTRAINT [PK_authors]
	PRIMARY KEY CLUSTERED ([a_id])
;

ALTER TABLE [books] 
 ADD CONSTRAINT [PK_books]
	PRIMARY KEY CLUSTERED ([b_id])
;

ALTER TABLE [genres] 
 ADD CONSTRAINT [PK_genres]
	PRIMARY KEY CLUSTERED ([g_id])
;

ALTER TABLE [genres] 
 ADD CONSTRAINT [UO_genres_g_name] UNIQUE NONCLUSTERED ([g_name])
;

ALTER TABLE [m2m_books_authors] 
 ADD CONSTRAINT [PK_m2m_books_authors]
	PRIMARY KEY CLUSTERED ([b_id],[a_id])
;

ALTER TABLE [m2m_books_genres] 
 ADD CONSTRAINT [PK_m2m_books_genres]
	PRIMARY KEY CLUSTERED ([b_id],[g_id])
;

ALTER TABLE [subscribes] 
 ADD CONSTRAINT [PK_subscribes]
	PRIMARY KEY CLUSTERED ([s_id])
;

ALTER TABLE [subscriptions] 
 ADD CONSTRAINT [PK_subscriptions]
	PRIMARY KEY CLUSTERED ([sb_id])
;

ALTER TABLE [subscriptions] 
 ADD CONSTRAINT [check_enum] CHECK ([sb_is_active] in ('Y', 'N'))
;

ALTER TABLE [m2m_books_authors] ADD CONSTRAINT [FK_m2m_books_authors_authors]
	FOREIGN KEY ([a_id]) REFERENCES [authors] ([a_id]) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE [m2m_books_authors] ADD CONSTRAINT [FK_m2m_books_authors_books]
	FOREIGN KEY ([b_id]) REFERENCES [books] ([b_id]) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE [m2m_books_genres] ADD CONSTRAINT [FK_m2m_books_genres_books]
	FOREIGN KEY ([b_id]) REFERENCES [books] ([b_id]) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE [m2m_books_genres] ADD CONSTRAINT [FK_m2m_books_genres_genres]
	FOREIGN KEY ([g_id]) REFERENCES [genres] ([g_id]) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE [subscriptions] ADD CONSTRAINT [FK_subscriptions_books]
	FOREIGN KEY ([sb_book]) REFERENCES [books] ([b_id]) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE [subscriptions] ADD CONSTRAINT [FK_subscriptions_subscribes]
	FOREIGN KEY ([sb_subscriber]) REFERENCES [subscribes] ([s_id]) ON DELETE Cascade ON UPDATE Cascade
;
