# KMH User Management APIs

The main aim of this project is to provide User Management APIs which are used for User, Roles and Right Management. Following are the main components of this project:
1. App_DB_Scripts: This consists of all the DB scripts of SQL Server. (".sql" file)
2. KMH_APIs.postman_collection: This consists of all the APIs with sample input data
3. Other files: Nodejs application

## Softwares required
- [VisualStudioCode] - Required for running the application
- [NodeJS] - Required as the application is developed using this software
- [SQLServer] - Required as the this is used for storing the data
- [Postman] - Required for testing the API's

## Following steps describes about the project setup for this application:
1. Installation:
Please make sure that you have all the softwares listed above.

2. Setup Database:
After installing SQL Server, Open SSMS (SQL Server Management Studio) and browse for the App_DB_Scripts.sql file placed in the root folder of this project. This file have 4 sections. They are:
*Note: (Execute scripts for each section at a time for better results)
"*" - represents manadatory runs

- Database Section: This is optional if you already have a Database. Run this section for a new database creation
- Login Section: This is optional if you already have a SQL Server username and password. If you are using Windows authentication please uncomment and execute the scripts.
    - Creates Login with UserName: KMH_Admin and Password:"kmh123". (You can change to your own username and password)
    - "KMH_User" is created for this login.
    - Other scripts for giving the login DB Owner and SYS Admin permissions
- "*"Schema Section: Creates Schema named "dev". Dont change the name and this is mandatory as this is used in the API
- "*"Tables Section: Creates all the required tables for the application. This is mandatory
- Insert Data Section: This is optional. Inserting a row in Roles and Rights lookup tables
- "*"Stored Procedure Section: Creates all the stored procedures required for the application. This is mandatory

3. Setup Node Project:
After downloading the files from the git, follow the below steps:
Once you have installed Nodejs the open the downloaded folder using Visual Studio code. 
Open the terminal (Top Menu --> Terminal --> New Terminal) displays a command prompt. Run the following commands in Terminal
    - npm install express
    - npm install body-parser
    - npm install tedious
    
The system automatically detects if there are any issues while running above commandes. It will ask you to run below command
    - npm audit fix
    
After successfully running all the above commands make sure that you have "node_modules" folder in the root directory
*Note: The reason "node_modules" is not uploaded here as it contains many files and it is easy to run the above commands locally

4. Set app.js: The Server port configuration is maintained here. This also uses the packages we intalled from Step 3
"3300" is the port number used presently in this file. The localhost opens the port with this number Ex: http://localhost:3300
*Note: You can change the port number if required. This application tested only for localhost only

5. Check package.json: This file consists of all the Step 3. installed software versions. Check for existance.

7. Set Database\connect.js: This consists of all the configurations related to SQL Server database. Provide the following details:
- Server Name
- Instance Name( if any)
- Username and Password
- Database Name
For checking the connection run the command "node connect.js" in the Terminal and the output should be "Database Connected"
*Note: run "cd" command until Database folder to run above command. Otherwise you will get a file not found error

This completes the configuration part of our application. Now let's run the application.

8. Running the application
For running the application use follwing command in the Terminal:
    "node app.js"
This is the start point of our application

After running you should get below comments:
The Server Started
Database Connected
This means the Server is activated and your API's are ready for use

9. Open the Postman application and using the KMH_APIs.postman_collection.json you can test all the API's
Just import the json file into your postman account and remember following changes:
    - API URL to be changed if you have changed the port number
    - Input data to be changed in Body of API as example data is kept.
    
Finish we are successfuly done with application.
