/*
This program implements an application to create and use a phone directory using a mysql database as data source for storing values
*/

import java.sql.*;

import java.util.Scanner;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.*;


class jdbcPhoneDirectory{


	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
   	static final String DB_URL = "jdbc:mysql://localhost/phone_directory";
   	static final String USER = "root";
   	static final String PASS = "";
	static List <CSVRecord> records =null;
	static int count;

	
					//Create the table
    public static void createTable(Connection con) throws SQLException{
    		String createDataBaseString=
    			"use phone_directory;";
    		String createTableString=
    			"create table phone_directory.directory (name varchar(10) not null,address varchar(20) not null,mobile varchar(10),home varchar(10),work varchar(10));";
    		String dropDataBaseString=
    			"drop table if exists phone_directory.directory ;";
    		PreparedStatement tableStatement=null;
    		try{
    			con.setAutoCommit(false);
    			tableStatement=con.prepareStatement(dropDataBaseString);
    			tableStatement.executeUpdate();
    			tableStatement=con.prepareStatement(createDataBaseString);
			tableStatement.executeUpdate();
    			tableStatement=con.prepareStatement(createTableString);
			tableStatement.executeUpdate();
    			con.commit();
		}catch(SQLException e){					//Error handling
			if(con==null){
				System.out.println("CONNECTION PROBLEM - CREATE TABLE");
			}
			else{
				try{
					System.err.print("Transaction is being rolled back");
					con.rollback();
				}catch(SQLException se){
					se.printStackTrace();
				}
			}
		}finally{
			if (tableStatement !=null) {
				tableStatement.close();
			}
			con.setAutoCommit(true);
		}
	}



					//Gets the input from the source file
	public static void csvGet(File source) throws FileNotFoundException,IOException{
		CSVParser parser=new CSVParser(new FileReader(source),CSVFormat.DEFAULT.withRecordSeparator("\n").withHeader("name","address","mobile","home","work"));
		records=parser.getRecords();
			
	}


	static void insertValues(Connection con) throws SQLException{
		PreparedStatement tableStatement =null;
		String insertValueString=
    			"insert into phone_directory.directory values( ?,?,?,?,?);";	
		try{
			con.setAutoCommit(false);
			tableStatement = con.prepareStatement(insertValueString);
			for (int i=1;i<records.size();i++){
				CSVRecord record=records.get(i);
				tableStatement.setString(1,record.get("name"));
				tableStatement.setString(2,record.get("address"));
				tableStatement.setString(3,record.get("mobile"));
				tableStatement.setString(4,record.get("home"));
				tableStatement.setString(5,record.get("work"));
				tableStatement.executeUpdate();
			}	
			con.commit();
			
		}catch(SQLException e){			//Error handling
			if(con!=null){
				try {
                		System.err.print("Transaction is being rolled back");
               		con.rollback();
            		}catch(SQLException se){
            			se.printStackTrace();
            		}
            	}else{
            		System.err.print("CONNECTION ERROR");
           	}		
		}finally{
			if (tableStatement !=null) {
				tableStatement.close();
			}
			con.setAutoCommit(true);
		}
	}


	public static void toDisplay(PreparedStatement queryStatement) throws SQLException{
		ResultSet rs=null;
		count=0;
		try{
			rs=queryStatement.executeQuery();
			while(rs.next()){
				System.out.print("Name:"+rs.getString("name"));
				System.out.print("Address:"+rs.getString("address"));
				System.out.print("Mobile:"+rs.getString("mobile"));
				System.out.print("Home:"+rs.getString("home"));
				System.out.print("work:"+rs.getString("work"));
				System.out.println();
				count++;
			}
			if(count==0){
				System.out.println("Sorry the searched value was not found!");
			}
		}catch(SQLException se){
			se.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			rs.close();
		}
	}

					//Searches the databases for full name match
	public static void searchByName(Connection con,String name) throws SQLException{
		PreparedStatement queryStatement=null;
		String queryString=
		"select name,address,mobile,home,work from phone_directory.directory where name = ?";
		try{
			queryStatement =con.prepareStatement(queryString);
			queryStatement.setString(1,name);
			toDisplay(queryStatement);
		}catch(SQLException se){
			se.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			queryStatement.close();
		}
	}	

					//searches the databases for partial match
	public static void searchByPartial(Connection con,String name) throws SQLException{
		PreparedStatement queryStatement=null;
		String queryString=
		"select name,address,mobile,home,work from phone_directory.directory where name like('%' ? '%');";
		try{
			queryStatement =con.prepareStatement(queryString);
			queryStatement.setString(1,name);
			toDisplay(queryStatement);
		}catch(SQLException se){
			se.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			queryStatement.close();
		}
	}	

					//searches the databases for number match
	public static void searchByNumber(Connection con,String number) throws SQLException{
		PreparedStatement queryStatement=null;
		String queryString=
		"select name,address,mobile,home,work from phone_directory.directory where home = ? or work= ? or mobile= ?";
		try{
			queryStatement =con.prepareStatement(queryString);
			queryStatement.setString(1,number);
			queryStatement.setString(2,number);
			queryStatement.setString(3,number);
			toDisplay(queryStatement);
		}catch(SQLException se){
			se.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			queryStatement.close();
		}
	}


					//main method
	public static void main(String args[]) throws SQLException,IOException,ClassNotFoundException{
		
		Scanner scanner=new Scanner(System.in);
		Connection conn = null;
		int choice;
		String name;
		String number;
		try{
			File source=new File("directory.csv");
			Class.forName(JDBC_DRIVER);		
			conn = DriverManager.getConnection(DB_URL,USER,PASS);				//connection is created
			createTable(conn);
			csvGet(source);
			insertValues(conn);
			do{
				System.out.println("1.Search by name\n2.Search by partial name\n3.Search by phone number\n4.Exit");
				choice=scanner.nextInt();
				switch(choice){							//recieves users choice
					case 1:								//search based on name
						System.out.println("Enter the name of the person whose number is to be searched");
						name=scanner.next();
						searchByName(conn,name);
						break;
					case 2:								//search based on partial name
						System.out.println("Enter the partial name of the person whose details are needed");
						name=scanner.next();
						searchByPartial(conn,name);
						break;
					case 3:								//search based on number
						System.out.println("Enter the phone number of the person to be searched");
						number=scanner.next();
						searchByNumber(conn,number);
						break;
					case 4:								
						System.out.println("Thank You");
						break;
					default:
						System.out.println("Please enter a valid choice");
						break;
				}	
			}while(choice<4);
		}catch(SQLException se){
			se.printStackTrace();
		}
	}
}





