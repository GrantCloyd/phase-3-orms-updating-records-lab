require 'pry'
require_relative "../config/environment.rb"

class Student
attr_reader :id
attr_accessor :name, :grade

 def initialize(name, grade, id = nil)
   @name = name 
   @grade = grade
   @id = id 
 end


  def self.create_table 
    sql = <<-SQL
      CREATE TABLE students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      ); 
      SQL
     
      DB[:conn].execute(sql)
      
    end

  def self.drop_table 
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save 
   if self.id 
    self.update
   else
  sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
         SQL

       DB[:conn].execute(sql, self.name, self.grade)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").first.first  
     end
    end

  def self.create(name, age)
    student = self.new(name,age)
    student.save
    student
  end

  def self.new_from_db(row)
    id, name, grade = row
    self.new(name, grade, id)
  end  

  def self.find_by_name(name)
  sql = "
        SELECT * 
        FROM students  
        WHERE name = '#{name}'
        "

     res= DB[:conn].execute(sql).map {|row| self.new_from_db(row)}.first    
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
    

end
