
use my_db2;


show tables;

-- Viewを作成。
-- storesとitemsテーブルを結合し、store_nameとitem_nameの情報を保持する仮想テーブルを定義
create view stores_items_view as
select st.name as store_name, it.name as item_name 
from stores as st
inner join items as it
on it.store_id = st.id;

-- 作成したView（stores_items_view）から全データを取得
select * from stores_items_view;

-- itemsテーブルの"Item 山田 1"という名前の商品を"new Item 山田1"に更新
update items set name="new Item 山田1" where name="Item 山田 1";


show tables;

-- information_schemaから、現在のデータベース（my_db2）内に存在するすべてのViewの情報を取得
select * from information_schema.Views where table_schema = "my_db2"\G

-- stores_items_viewの作成SQL（定義）を表示
show create view stores_items_view\G

-- stores_items_viewの中からstore_nameが"山田商店"のデータのみを抽出
select * from stores_items_view where store_name ="山田商店";

-- stores_items_viewのデータをstore_nameで並べ替えて、最初の10件を取得
select * from stores_items_view order by store_name limit 10;

-- stores_items_viewのstore_nameごとにアイテム数をカウントし、store_nameの昇順で結果を表示
select store_name, count(*) 
from stores_items_view 
group by store_name 
order by store_name;

-- Viewの定義を変更して、新たにstore_idとitem_idを追加。結合キーを含む情報を追加してViewを再定義
alter view stores_items_view as
select st.id as store_id, it.id as item_id, st.name as store_name, it.name as item_name 
from stores as st
inner join items as it
on it.store_id = st.id;

-- 再定義されたstores_items_viewからデータを取得
select * from stores_items_view;

-- stores_items_viewの名前をnew_stores_items_viewに変更。Viewの名前を変更したい場合に使用
rename table stores_items_view to new_stores_items_view;

select * from new_stores_items_view limit 10;

-- stores_items_viewを削除。既存のViewを使わなくなった場合は削除してリソースを解放する
drop view new_stores_items_view;