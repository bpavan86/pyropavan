# KMH User Management APIs

The main aim of this project is to provide User Management APIs which are used for User, Roles and Right Management. Following are the main components of this project:
1. App_DB_Scripts: This consists of all the DB scripts of SQL Server
2. KMH_APIs.postman_collection: This consists of all the APIs with sample input data
3. README: Manual for running the project
4. Other files: Nodejs application

## Softwares required
- [VisualStudioCode] - IDE for developing the application
- [NodeJS] - Application developed using this. Download the software
- [SQLServer] - Database used for storing the project data 

## Following steps describes about the project setup from the scratch for this application:
1. Installation:
Please make sure that you have all the softwares listed above.

2. Setup Database :
Open SSMS and browse for the App_DB_Scripts.sql file placed in the root folder of this project
This file have 4 sections: (Execute scripts for each section at a time for better results)
- Database Section: Creates Database named KMHApp
- Login Section: This is optional. 
    - If you dont have a SQL Authentication please run these scripts with required parameters. 
    - This is designed with UserName: KMH_Admin and Password:"kmh123". 
    - "KMH_User" is created for this login.
    - Other scripts for giving the login DB Owner and SYS Admin permissions
- Schema Section: Creates Schema named dev
- Tables Section: Creates all the required tables for the application
- Insert Data Section: This is optional. This for inserting each row in Roles and Rights
- Stored Procedure Section: Creates all the stored procedures required for the application

3. Setup Node Project:
After downloading the files from the git, follow the below steps:
Once you have installed Node, let’s try building REST API. Create a file named “app.js”, and paste the following code:
- Run the following commands in Terminal
    - npm install express
    - npm install body-parser
    - npm install tedious
    If there are any issues while installation you might be asked to run below command
    - npm audit fix
    After running all the above commands make sure that you have node_modules folder in the root

4. app.js: The Server port configuration is mentioned here. This also uses the packages we intalled from Step 3.
3300 is the port number used presently. The localhost opens the port with this number Ex: http://localhost:3300
*Note: This application can only be used for localhost

5. package.json: This file consists of all the 3. step installed software versions

5. Database\connect.js: This consists of all the configuration related to SQL Server database. Provide the following details:
- Server Name
- Instance Name( if any)
- Username and Password
- Database Name
For checking the connection run the command "node connect.js" and the output should be "Database Connected"
*Note: run "cd" command until Database folder to run above command

6. For running the application use follwing command in the Terminal:
node app.js
After running you should get below comments:
The Server Started
Database Connected
This means your API's are ready for use

7. Using the KMH_APIs.postman_collection.json you can test all the API's
Just import the json file into your postman account and remeber following changes:
    - API URL to be changes (They are presently linked to localhost)
    - Input data to be changed in Body (Expects json and sample is kept)