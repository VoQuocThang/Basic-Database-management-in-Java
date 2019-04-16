
import java.awt.Cursor;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.util.List;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;


class CheckLogin {
	private String username;
	private String _password;
	private ResultSet cursor;
	public CheckLogin(String a,char[] b){
		username=a;
		_password=String.valueOf(b);
	}
	
	
	public boolean getState() {
		boolean check=false;
		try {
			  
		      String query = "Select * from Account where username =? and _password =?";
		      
		      PreparedStatement s =  SimpleSQLSever.c.prepareStatement(query);
		      s.setString(1, username);
		      s.setString(2, _password);
		      
		      cursor = s.executeQuery();
		      
		      if(cursor.next()) {
		    	   check = true;
		      }
		   
	         
		    }catch(Exception e) {
			  e.printStackTrace();
		    }
		    finally{
		    	try {
		    	     cursor.close();
		    	} 
		    	catch(Exception e) {
		    		e.printStackTrace();
		    	}
		    }
		return check;
	}
}


class Login extends JFrame implements ActionListener{
	JLabel _username;
	JTextField username;
	JLabel _password;
	JPasswordField password;
	public Login(){
		//Buttons
		JButton ok = new JButton();
		ok.setText("OK");
		ok.addActionListener(this);
		
		JButton cancel = new JButton();
		cancel.setText("CANCEL");
		cancel.addActionListener(this);
		//Text
		 _username = new JLabel();
		 username = new JTextField();
		_username.setText("Username");
		_password = new JLabel();
		 password = new JPasswordField();
		_password.setText("Password");
		
		//Enabled gUI
		this.add(_username);
		this.add(username);
		this.add(_password);
		this.add(password);
	    this.add(ok);
	    this.add(cancel);
	    
	    //Frame
		setTitle("Sign In");
		setSize(600,150);
	    this.setLayout(new GridLayout(3,3));
		setVisible(true);
	}
	public void actionPerformed(ActionEvent e) {
		    if(e.getActionCommand().equals("OK")) {
		    	        CheckLogin Clogin = new CheckLogin(username.getText(),password.getPassword());
		    	        if(Clogin.getState()) {
		    	        	 JOptionPane.showMessageDialog(null, "Login successfully",null,JOptionPane.INFORMATION_MESSAGE);
		    	        	 StaffController staff= new StaffController();
		    	        	 this.setVisible(false);
		    	        	 this.dispose();
		    	        }
		    	        else {
		    	        	 JOptionPane.showMessageDialog(null, "Login failed",null,JOptionPane.ERROR_MESSAGE);
		    	        	
		    	        }
		    	       
		    }
		    else{
		    	        username.setText("");
		    	        password.setText("");
		    }
	}
}


class StaffInfo extends JFrame implements ActionListener {
	 JLabel _id,_name,_phg,id;
	 JTextField name,phg;
	 JButton Save;
	 JButton Cancel;
	 public StaffInfo(String a,String b,String c) {
		   JPanel panel=new JPanel();
		  _id = new JLabel("ID: ");
		  _name=new JLabel("Name: ");
		  _phg=new JLabel("PHG: ");
		   id=new JLabel(a);
		   name=new JTextField(b);
		   phg=new JTextField(c);
		   JButton Save = new JButton("Save");
		   JButton Cancel= new JButton("Cancel");
		   Save.addActionListener(this);
		   Cancel.addActionListener(this);
		  panel.add(_id);
		  panel.add(id);
		  panel.add(_name);
		  panel.add(name);
		  panel.add(_phg);
		  panel.add(phg);
		  panel.add(Save);
		  panel.add(Cancel);
		  panel.setLayout(new GridLayout(4,2));
		  add(panel);
		  setSize(300,350);
		  setVisible(true);
	 }
	 public void update() {
		 try {
		  String query = "Update Employee set name=?,phg=? where id='"+id.getText()+"'";
	      PreparedStatement s =  SimpleSQLSever.c.prepareStatement(query);
	      s.setString(1, name.getText());
	      s.setString(2, phg.getText());
	      s.executeUpdate();
	      JOptionPane.showMessageDialog(null, "Update succfessfully.Please click see all to see changes",null, JOptionPane.INFORMATION_MESSAGE);
	      this.setVisible(false);
     	  this.dispose();
		 } catch(Exception e) {
			 
		      JOptionPane.showMessageDialog(null, "ERROR",null, JOptionPane.ERROR_MESSAGE);

		 }
	 }
	 public void actionPerformed(ActionEvent e) {
		 if(e.getActionCommand().equals("Save")) {
			     update();
		 }
		 else {
			    this.dispose();
		 }   
	 }
}


class StaffController extends JFrame implements ActionListener {
	  private static int MAXSIZE=2000;
	  private JTextField searchtf;
	  private JRadioButton R_id;
	  private JRadioButton R_name;
	  private JRadioButton R_PHG;
	  private JTable list;
	  private DefaultTableModel dmt;
      private  JScrollPane listPane;
	  public StaffController() {
		  
		  //Crete search Box 
		  JPanel searchPanel = new JPanel();
		  searchtf = new JTextField(10);
		  JButton search = new JButton();
		  searchPanel.add(searchtf);
		  searchPanel.add(search);
		  search.setText("Search");
		  search.addActionListener(this);
		  R_id=new JRadioButton();
		  R_id.setText("ID");
		  searchPanel.add(R_id);
	      R_name=new JRadioButton();
		  R_name.setText("Name");
		  searchPanel.add(R_name);
		  R_PHG=new JRadioButton();
		  R_PHG.setText("PHG");
		  searchPanel.add(R_PHG);
		  
		  add(searchPanel);
		 
		  
		  //panel for list 
		  
		  dmt = new DefaultTableModel();
		  dmt.setColumnIdentifiers(new Object[] {"ID","NAME","PHG"} );
		  getList();
		  list = new JTable(dmt);
		  
	      listPane = new JScrollPane(list);
	      
		  add(listPane);
		  //panel for buttons
		  JPanel panel = new JPanel();
		  JButton insert = new JButton();
		  insert.setText("Insert");
		  insert.addActionListener(this);
		  JButton delete = new JButton();
		  delete.setText("Delete");
		  delete.addActionListener(this);
		  
		  JButton rewrite = new JButton();
		  rewrite.setText("Update");
		  rewrite.addActionListener(this);
		  JButton seeAll = new JButton();
		  seeAll.setText("See all");
		  seeAll.addActionListener(this);
		  panel.add(insert);
		  panel.add(delete);
		  panel.add(rewrite);
		  panel.add(seeAll);
		  add(panel);
		  setSize(550,300);
		  setTitle("Staff Management");
		  setLayout(new GridLayout(3,1));
		  setVisible(true);
	  }
	  
	  public void getList() {
		 
		  int cnt=0;
		  dmt.setRowCount(0);
		  Connection c=null;
			try {
				 
			      String query = "Select * from Employee";
			      Statement s =  SimpleSQLSever.c.createStatement();
			      ResultSet cursor = s.executeQuery(query);
			      while(cursor.next()) {
			              
			    		 dmt.addRow(new Object [] { cursor.getString(1),cursor.getString(2),cursor.getString(3) });
			    		
			      }
			  
			   }catch(Exception e) {
				  e.printStackTrace();
			    }
			    
		
		  
	  }
	  public void searching(String object,String type) {
		   
			try {
		      String query = "Select * from Employee where "+type+" = ?";
			      PreparedStatement s =  SimpleSQLSever.c.prepareStatement(query);
			      s.setString(1, object);
			      ResultSet cursor = s.executeQuery();
			      dmt.setRowCount(0);
			      while(cursor.next()) {
			    	  dmt.addRow(new Object [] { cursor.getString(1),cursor.getString(2),cursor.getString(3) });
			      }
			  
		         
			    }catch(Exception e) {
				  e.printStackTrace();
			    }
			
		  
	  }
	  
	  public void insert() {
		    JTextField id = new JTextField();
		    JTextField name = new JTextField();
		    JTextField phg = new JTextField();
		    Object[] account = {
		    		"ID:" , id,
		    		"Name:" , name,
		    		"PHG:" , phg,
		    };
		    int option = JOptionPane.showConfirmDialog(null, account,"Filling the form",JOptionPane.OK_CANCEL_OPTION);
		    if(option == JOptionPane.OK_OPTION) {
		    	 try{
		    	    String query = "Insert into Employee "+"Values ('"+id.getText()+"', '"+name.getText()+"' ,'"+phg.getText()+"');";
			         Statement s =  SimpleSQLSever.c.createStatement();
			         s.executeUpdate(query);
			         dmt.addRow(new Object[]{ id.getText(),name.getText(),phg.getText() });
			         JOptionPane.showMessageDialog(null, "Insert successfully", "", JOptionPane.INFORMATION_MESSAGE);
		    	 }catch(Exception e) {
		    		     JOptionPane.showMessageDialog(null, "ERROR","", JOptionPane.ERROR_MESSAGE);
		    	 }
		    	 
		    }
		    
	  }
	  public void delete() {
		   int column=0;
		   int row = list.getSelectedRow();
		   String id = String.valueOf(dmt.getValueAt(row, column));
		   int option =JOptionPane.showConfirmDialog(null,"DO YOU REALLY WANT TO DELETE THIS ROW","", JOptionPane.YES_NO_OPTION);
		   if(option==JOptionPane.YES_OPTION) {
		   try{
	    	     String query = "Delete from Employee where ID = '"+id+"'";
		         Statement s =  SimpleSQLSever.c.createStatement();
		         s.executeUpdate(query);
	    	 }catch(Exception e) {
	    		 
	    	 }
		   
		   dmt.removeRow(row);
		  }
	  }
	  
	  public void update() {
		  
		  int row = list.getSelectedRow();
		  String id = String.valueOf(dmt.getValueAt(row, 0));
		  String name = String.valueOf(dmt.getValueAt(row, 1));
		  String phg = String.valueOf(dmt.getValueAt(row, 2));
		  StaffInfo info = new StaffInfo(id,name,phg);
	  }
		   
	  public void actionPerformed(ActionEvent e) {
		      if(e.getActionCommand().equals("Search")) {
		    	      
		    	      if(R_id.isSelected()) {
		    	    	    searching (searchtf.getText(),"ID" ); 
		    	    	    R_id.setSelected(false);
		    	      }
		    	      else if(R_name.isSelected()) {
		    	    	    searching (searchtf.getText(),"NAME" ); 
		    	    	    R_name.setSelected(false);
		    	      }
		    	      else if(R_PHG.isSelected()) {
		    	    	  searching (searchtf.getText(),"PHG" ); 
		    	    	  R_PHG.setSelected(false);
		    	      }
		      }
		      else if(e.getActionCommand().equals("See all")) {
		    	    getList();
		    	 
		      }
		      else if(e.getActionCommand().equals("Insert")) {
		    	        insert();
		      }
		      else if(e.getActionCommand().equals("Delete")) {
		    	        delete();
		      }
		      else if(e.getActionCommand().equals("Update")) {
		    	       update();
		      }
		      list.setModel(dmt);
	  }
	 
}


public class SimpleSQLSever {
  
    public static  Connection c=null;
	
	public SimpleSQLSever() {
		 try {
		  String user = "sa";
		  String password="lethiloi1999";
		  Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		  String url = "jdbc:sqlserver://localhost:1433;instance=SQLEXPRESS;databaseName=AccountDatabase";
	      c = DriverManager.getConnection(url, user, password);
		 }
		 catch(Exception e) {
			 
		 }
	}
	public static void main(String[] args) {
         SimpleSQLSever temp = new SimpleSQLSever();
              Login login=  new Login();
      
	}

}
