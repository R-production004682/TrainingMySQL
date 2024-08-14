select database();

#演習問題

#以下の演習問題を行います。

#問題文に対応したSQLを作成してください。


#1. customersテーブルから、ageが28以上40以下でなおかつ、nameの末尾が「子」の人だけに絞り込んでください。
#そして、年齢で降順に並び替え、検索して先頭の5件の人のnameとageだけを表示してください。

select name , age from customers where (age >= 28 and age < 40) and name like "%子" order by age desc limit 5;


#2. receiptsテーブルに、「customer_idが100」「 store_nameがStore X」「priceが10000」のレコードを挿入してください。


#3. 2で挿入してレコードを削除してください


#4. prefecturesテーブルから、nameが「空白もしくはNULL」のレコードを削除してください


#5. customersテーブルのidが20以上50以下の人に対して、年齢を+1してレコードを更新してください
#(ただし、BETWEENを使うこと)


#6. studentsテーブルのclass_noが6の人すべてに対して、1～5のランダムな値でclass_noを更新してください


#7. class_noが3または4の人をstudentsテーブルから取り出します。取り出した人のheightに10を加算して、その加算した全値よりも、heightの値が小さくてclass_noが1の人をstudentsテーブルから取り出してください。
#(ただし、IN, ALLを使うこと)


#8. employeesテーブルのdepartmentカラムには、「 営業部 」のような形で部署名の前後に空白が入っています。この空白を除いた形にテーブルを更新してください