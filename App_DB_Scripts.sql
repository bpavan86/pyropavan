--##########################################################################
--DATABASE SECTION
--Checking Database and creating it
IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'KMHApp')
BEGIN
	CREATE DATABASE KMHApp;
END
--##########################################################################

-------Run the below scripts if you don't have a designated login
--##########################################################################
--LOGIN & USER SECTION
--Create a Login for the database
--CREATE LOGIN KMH_Admin
--WITH PASSWORD = 'kmh123'
--ALTER LOGIN KMH_ADMIN WITH default_database = KMHApp
--CREATE USER KMH_User FROM LOGIN KMH_Admin;
--EXEC SP_ADDROLEMEMBER 'db_owner', 'KMH_User';
--EXEC SP_ADDSRVROLEMEMBER 'KMH_Admin', 'sysadmin';
--##########################################################################

--##########################################################################
--SCHEMA SECTION
--Using the created database
USE KMHApp
--Checking schema and creating it
IF (SCHEMA_ID('dev') IS NULL)
BEGIN
	EXEC('CREATE SCHEMA dev;');
END
--##########################################################################

--##########################################################################
--TABLES SECTION
--Checking and creating User Account table
IF (OBJECT_ID('dev.tbl_data_UserAccount') IS NULL)
BEGIN
	CREATE TABLE dev.tbl_data_UserAccount 
	(
		user_account_id INT PRIMARY KEY IDENTITY (1, 1),
		given_name VARCHAR (50) NOT NULL,
		surname VARCHAR (50) NOT NULL,
		email VARCHAR (50),
		phone VARCHAR(20)
	)
END

--Checking and creating Roles table
IF (OBJECT_ID('dev.tbl_lkup_Role') IS NULL)
BEGIN
	CREATE TABLE dev.tbl_lkup_Role 
	(
		role_id INT PRIMARY KEY IDENTITY (1, 1),
		role_name VARCHAR (50) NOT NULL
	)
END

--Checking and creating Right table
IF (OBJECT_ID('dev.tbl_lkup_Right') IS NULL)
BEGIN
	CREATE TABLE dev.tbl_lkup_Right 
	(
		right_id INT PRIMARY KEY IDENTITY (1, 1),
		right_name VARCHAR (50) NOT NULL
	)
END

--Checking and creating Role and user mapping table
IF (OBJECT_ID('dev.tbl_map_Role_User') IS NULL)
BEGIN
	CREATE TABLE dev.tbl_map_Role_User 
	(
		map_role_user_id INT PRIMARY KEY IDENTITY (1, 1),
		role_id int NOT NULL,
		user_account_id int Not NULL,
		FOREIGN KEY (role_id) REFERENCES dev.tbl_lkup_Role (role_id),
		FOREIGN KEY (user_account_id) REFERENCES dev.tbl_data_UserAccount (user_account_id)
	)
END

--Checking and creating Rights and Role mapping table
IF (OBJECT_ID('dev.tbl_map_Right_Role') IS NULL)
BEGIN
	CREATE TABLE dev.tbl_map_Right_Role 
	(
		map_right_role_id INT PRIMARY KEY IDENTITY (1, 1),
		right_id int NOT NULL,
		role_id int Not NULL,
		FOREIGN KEY (right_id) REFERENCES dev.tbl_lkup_Right (right_id),
		FOREIGN KEY (role_id) REFERENCES dev.tbl_lkup_Role (role_id)
	)
END
--##########################################################################

--##########################################################################
--INSERT DATA SECTION

--insert scripts
--Role Data
IF NOT EXISTS(SELECT 1 FROM dev.tbl_lkup_Role WHERE role_name = 'Admin')
INSERT INTO dev.tbl_lkup_Role(role_name) VALUES('Admin')

--Rights Data
IF NOT EXISTS(SELECT 1 FROM dev.tbl_lkup_Right WHERE right_name = 'Read')
INSERT INTO dev.tbl_lkup_Right(right_name) VALUES('Read')

--DBCC CHECKIDENT ('dev.tbl_lkup_Right', RESEED, 0)
--##########################################################################

--##########################################################################
--STORED PROCEDURE SECTION

--Checking and creating the fetching users stored procedure
IF (OBJECT_ID('dev.sp_sel_GetUsers') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_sel_GetUsers
END
GO

CREATE PROCEDURE dev.sp_sel_GetUsers 
	(@User_Account_ID INT = '')
AS
BEGIN
	IF @User_Account_ID = ''
		SELECT user_account_id,given_name,surname,email,phone FROM dev.tbl_data_UserAccount;
	ELSE
		SELECT user_account_id,given_name,surname,email,phone FROM dev.tbl_data_UserAccount WHERE user_account_id = @User_Account_ID;
END
GO

--Checking and creating the fetching roles stored procedure
IF (OBJECT_ID('dev.sp_sel_GetRoles') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_sel_GetRoles
END
GO

CREATE PROCEDURE [dev].[sp_sel_GetRoles] 
	(@Role_ID INT = '')
AS
BEGIN
	IF @Role_ID = ''
		SELECT role_id,role_name FROM dev.tbl_lkup_Role;
	ELSE
		SELECT role_id,role_name FROM dev.tbl_lkup_Role WHERE role_id = @Role_ID;
END
GO

--Checking and creating the fetching rights stored procedure
IF (OBJECT_ID('dev.sp_sel_GetRights') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_sel_GetRights
END
GO

CREATE PROCEDURE [dev].[sp_sel_GetRights] 
	(@Right_ID INT = '')
AS
BEGIN
	IF @Right_ID = ''
		SELECT right_id,right_name FROM dev.tbl_lkup_Right;
	ELSE
		SELECT right_id,right_name FROM dev.tbl_lkup_Right WHERE right_id = @Right_ID;
END
GO

--Checking and creating the fetching user roles stored procedure
IF (OBJECT_ID('dev.sp_sel_GetUserRoles') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_sel_GetUserRoles
END
GO

CREATE PROCEDURE [dev].[sp_sel_GetUserRoles]
	(@User_ID VARCHAR(50) = NULL,
	 @Roles VARCHAR(100) = NULL)
AS
BEGIN
DECLARE @Query varchar(1000)
DECLARE @FinalQuery varchar(1000)

Set @Query = 'SELECT map.user_account_id
	,(useracc.given_name + '' '' + useracc.surname) as fullname
	,map.role_id
	,rolelk.role_name 
FROM dev.tbl_map_Role_User map
INNER JOIN dev.tbl_lkup_Role rolelk ON rolelk.role_id = map.role_id
INNER JOIN dev.tbl_data_UserAccount useracc ON useracc.user_account_id = map.user_account_id'
	IF (@Roles IS NULL and @User_ID IS NULL) 
		SET @FinalQuery = @Query
	ELSE IF (@Roles IS NOT NULL and @User_ID IS NOT NULL)
		Set @FinalQuery = @Query + ' WHERE map.user_account_id = ' + @User_ID + ' and map.role_id IN 
			(Select value from STRING_SPLIT(''' + @Roles + ''', '',''))'
	ELSE IF @Roles IS NULL
		Set @FinalQuery = @Query + ' WHERE map.user_account_id = ' + @User_ID
	ELSE IF @User_ID IS NULL
		Set @FinalQuery = @Query + ' WHERE map.role_id IN (Select value from STRING_SPLIT(''' + @Roles + ''', '',''))'

	EXECUTE(@FinalQuery + ' ORDER BY map.user_account_id')
END
GO

--Checking and creating the fetching user roles stored procedure
IF (OBJECT_ID('dev.sp_sel_GetRoleRights') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_sel_GetRoleRights
END
GO

CREATE PROCEDURE [dev].[sp_sel_GetRoleRights]
	(@Role_ID VARCHAR(50) = NULL,
	 @Rights VARCHAR(100) = NULL)
AS
BEGIN
DECLARE @Query varchar(1000)
DECLARE @FinalQuery varchar(1000)

Set @Query = 'SELECT map.role_id, rolelk.role_name, map.right_id
	,rightlk.right_name FROM dev.tbl_map_Right_Role map
INNER JOIN dev.tbl_lkup_Role rolelk ON rolelk.role_id = map.role_id
INNER JOIN dev.tbl_lkup_Right rightlk ON rightlk.right_id = map.right_id'
	IF (@Role_ID IS NULL and @Rights IS NULL)
		SET @FinalQuery = @Query
	ELSE IF (@Role_ID IS NOT NULL and @Rights IS NOT NULL)
		Set @FinalQuery = @Query + ' WHERE map.role_id = ' + @Role_ID + ' and map.right_id IN 
			(Select value from STRING_SPLIT(''' + @Rights + ''', '',''))'
	ELSE IF @Role_ID IS NULL
		Set @FinalQuery = @Query + ' WHERE map.right_id IN (Select value from STRING_SPLIT(''' + @Rights + ''', '',''))'
	ELSE IF @Rights IS NULL
		Set @FinalQuery = @Query + ' WHERE map.role_id = ' + @Role_ID

	EXECUTE(@FinalQuery + ' ORDER BY map.role_id')
END
GO

--Checking and creating the inserting/updating new users stored procedure
IF (OBJECT_ID('dev.sp_mod_InsUptUsers') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_InsUptUsers
END
GO

CREATE PROCEDURE dev.sp_mod_InsUptUsers
	(@given_name VARCHAR(50),
	@surname VARCHAR(50),
	@email VARCHAR(50),
	@phone VARCHAR(20))
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @User_Account_ID AS INT
	SELECT @User_Account_ID = user_account_id FROM dev.tbl_data_UserAccount 
		WHERE given_name = trim(@given_name) and surname = trim(@surname)
	IF @User_Account_ID IS NULL
		INSERT INTO dev.tbl_data_UserAccount(given_name,surname,email,phone)
			VALUES(@given_name,@surname,@email,@phone)
	ELSE
		UPDATE dev.tbl_data_UserAccount SET given_name = @given_name, surname = @surname, email = @email, phone = @phone
			WHERE user_account_id = @User_Account_ID
END
GO

--Checking and creating the deleting users stored procedure
IF (OBJECT_ID('dev.sp_mod_DeleteUsers') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_DeleteUsers
END
GO

CREATE PROCEDURE dev.sp_mod_DeleteUsers
	(@User_Account_ID VARCHAR(100))
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM dev.tbl_data_UserAccount WHERE user_account_id IN (@User_Account_ID)
END
GO

--Checking and creating the insert new roles stored procedure
IF (OBJECT_ID('dev.sp_mod_InsertRoles') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_InsertRoles
END
GO

CREATE PROCEDURE dev.sp_mod_InsertRoles
	(@Role_Name VARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS(SELECT 1 FROM dev.tbl_lkup_Role WHERE role_name = @Role_Name)
		INSERT INTO dev.tbl_lkup_Role(role_name) VALUES(@Role_Name)
END
GO

--Checking and creating the deleting roles stored procedure
IF (OBJECT_ID('dev.sp_mod_DeleteRoles') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_DeleteRoles
END
GO

CREATE PROCEDURE dev.sp_mod_DeleteRoles
	(@Role_ID VARCHAR(100))
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM dev.tbl_lkup_Role WHERE role_id IN (@Role_ID)
END
GO

--Checking and creating the insert new rights stored procedure
IF (OBJECT_ID('dev.sp_mod_InsertRights') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_InsertRights
END
GO

CREATE PROCEDURE dev.sp_mod_InsertRights
	(@Right_Name VARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS(SELECT 1 FROM dev.tbl_lkup_Right WHERE right_name = @Right_Name)
		INSERT INTO dev.tbl_lkup_Right(right_name) VALUES(@Right_Name)
END
GO

--Checking and creating the deleting rights stored procedure
IF (OBJECT_ID('dev.sp_mod_DeleteRights') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_DeleteRights
END
GO

CREATE PROCEDURE dev.sp_mod_DeleteRights
	(@Right_ID VARCHAR(100))
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM dev.tbl_lkup_Right WHERE right_id IN (@Right_ID)
END
GO

--Checking and creating the insert link for Roles and User stored procedure
IF (OBJECT_ID('dev.sp_mod_InsertUserRoles') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_InsertUserRoles
END
GO

CREATE PROCEDURE dev.sp_mod_InsertUserRoles
	(@Roles VARCHAR(100),
	 @UserID INT)
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dev.tbl_map_Role_User(role_id,user_account_id)
	Select value,@UserID from STRING_SPLIT(@Roles, ',') roles Where NOT EXISTS 
		(Select 1 from dev.tbl_map_Role_User where user_account_id = @UserID and role_id = roles.value)
END
GO

--Checking and creating the delete link for Roles and User stored procedure
IF (OBJECT_ID('dev.sp_mod_DeleteUserRoles') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_DeleteUserRoles
END
GO

CREATE PROCEDURE [dev].[sp_mod_DeleteUserRoles]
	(@Roles VARCHAR(100),
	 @UserID INT)
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM dev.tbl_map_Role_User WHERE role_id IN (Select value from STRING_SPLIT(@Roles, ',')) AND user_account_id = @UserID
END
GO

--Checking and creating the insert link for Rights and Roles stored procedure
IF (OBJECT_ID('dev.sp_mod_InsertRolesRight') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_InsertRolesRight
END
GO

CREATE PROCEDURE dev.sp_mod_InsertRolesRight
	(@Rights VARCHAR(100),
	 @RoleID INT)
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dev.tbl_map_Right_Role(right_id,role_id)
	Select value,@RoleID from STRING_SPLIT(@Rights, ',') rights Where NOT EXISTS 
		(Select 1 from dev.tbl_map_Right_Role where role_id = @RoleID and right_id = rights.value)
END
GO

--Checking and creating the delete link for Rights and Role stored procedure
IF (OBJECT_ID('dev.sp_mod_DeleteRoleRights') IS NOT NULL)
BEGIN
	DROP PROCEDURE dev.sp_mod_DeleteRoleRights
END
GO

CREATE PROCEDURE [dev].[sp_mod_DeleteRoleRights]
	(@Rights VARCHAR(100),
	 @RoleID INT)
AS
BEGIN
	SET NOCOUNT ON
	DELETE dev.tbl_map_Right_Role WHERE right_id IN (Select value from STRING_SPLIT(@Rights, ',')) AND role_id = @RoleID
END
GO

--##########################################################################
