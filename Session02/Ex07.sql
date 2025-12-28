DROP DATABASE DatabaseEx07;
CREATE DATABASE DatabaseEx07;
USE DatabaseEx07;

CREATE TABLE Student(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL
);

CREATE TABLE Teacher(
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL,
    teacher_email VARCHAR(255) UNIQUE
);

CREATE TABLE Class(
  class_id INT PRIMARY KEY,
  class_name VARCHAR(255) NOT NULL,
  school_year VARCHAR(20) NOT NULL
);

CREATE TABLE Subject(
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(255) NOT NULL,
    credit INT NOT NULL,

    CONSTRAINT chk_credit  CHECK (credit > 0)
);

CREATE TABLE Student_Class (
   student_id INT NOT NULL,
   class_id INT NOT NULL,
   join_date DATE NOT NULL,

   PRIMARY KEY (student_id, class_id),
   CONSTRAINT fk_sc_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
   CONSTRAINT fk_sc_class FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

CREATE TABLE Teacher_Class (
    teacher_id INT NOT NULL,
    class_id INT NOT NULL,
    role VARCHAR(50),

    PRIMARY KEY (teacher_id, class_id),
    CONSTRAINT fk_tc_teacher FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id),
    CONSTRAINT fk_tc_class FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

CREATE TABLE Teacher_Subject (
    teacher_id INT,
    subject_id INT,
    PRIMARY KEY (teacher_id, subject_id),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);


CREATE TABLE Score(
    student_id INT,
    subject_id INT,
    class_id INT,
    process_score DECIMAL(4,2),
    final_score DECIMAL(4,2),

    PRIMARY KEY (student_id, subject_id, class_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

