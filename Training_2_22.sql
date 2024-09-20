USE my_db3;

-- CHECK制約の使用例
CREATE TABLE customers
(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT CHECK (age >= 20)  -- 20歳以上でなければエラー
);

-- ageが20未満のため、2行目の挿入でエラーになる
INSERT INTO customers (id, name, age)
VALUES
    (1, 'Taro', 21),
    (2, 'Jiro', 19);

-- 複数のカラムに対するCHECK制約
CREATE TABLE students 
(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    gender CHAR(1),
    CONSTRAINT chk_students CHECK ((age >= 15 AND age <= 20) AND (gender = 'F' OR gender = 'M'))
);

-- 正常に挿入される
INSERT INTO students VALUES (1, 'Taro', 18, 'M');
INSERT INTO students VALUES (2, 'Sachiko', 18, 'F');

-- ageが15よりも小さいため、3行目の挿入でエラーになる
INSERT INTO students VALUES (3, 'Maki', 14, 'F');

-- 主キー制約の使用例
CREATE TABLE employees
(
    company_id INT,
    employee_code CHAR(8),
    name VARCHAR(255),
    age INT,
    PRIMARY KEY (company_id, employee_code)
);


insert into employees (company_id, employee_code, name, age)
values
    (1, "00000001", "Taro", 19), # 主キーが一意であるため、1行目は正常に挿入される
    (null, "00000001", "Taro", 19); # 主キーに設定されているカラムに、NULLは入れられないのでエラー
