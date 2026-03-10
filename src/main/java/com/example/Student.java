package com.example;

import java.util.Date;

public class Student {
    // Existing fields
    private String regd_no;
    private String name;
    private String fathername;
    private String mothername;
    private String email;
    private String phone;
    private String dept;
    private String studentClass;
    private Date dob;
    private String gender;

    // New fields from your database
    private String admno;
    private String rank;
    private String adtype;
    private String joincate;
    private String village;
    private String mandal;
    private String dist;
    private String pincode;

    // --- Getters and Setters for all fields ---

    public String getRegd_no() { return regd_no; }
    public void setRegd_no(String regd_no) { this.regd_no = regd_no; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getFathername() { return fathername; }
    public void setFathername(String fathername) { this.fathername = fathername; }

    public String getMothername() { return mothername; }
    public void setMothername(String mothername) { this.mothername = mothername; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDept() { return dept; }
    public void setDept(String dept) { this.dept = dept; }

    public String getStudentClass() { return studentClass; }
    public void setStudentClass(String studentClass) { this.studentClass = studentClass; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAdmno() { return admno; }
    public void setAdmno(String admno) { this.admno = admno; }

    public String getRank() { return rank; }
    public void setRank(String rank) { this.rank = rank; }

    public String getAdtype() { return adtype; }
    public void setAdtype(String adtype) { this.adtype = adtype; }

    public String getJoincate() { return joincate; }
    public void setJoincate(String joindate) { this.joincate = joindate; }

    public String getVillage() { return village; }
    public void setVillage(String village) { this.village = village; }

    public String getMandal() { return mandal; }
    public void setMandal(String mandal) { this.mandal = mandal; }

    public String getDist() { return dist; }
    public void setDist(String dist) { this.dist = dist; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
}