# Realm Sampler

# 概要
[Realm](https://realm.io/)を用いたToDoアプリの基礎

# 機能
[DONE]
- TODOの追加、
- TODOの削除
- TODOの編集
- TODOの期限追加
- TODOのカテゴリー決定
- カテゴリーごとの表示
- カテゴリ-の追加

[追加予定]
- TODOの期限のタイミングでの通知

# CRUD
CRUDのやり方は、[Realm Docs](https://realm.io/jp/docs/swift/latest/)のとおりです。

## モデルの設計
ToDoModelのカラムは以下のとおり
- id プライマリーキー(Int)
- todo todoの内容(String)
- category todoのカテゴリー(CategoryModel)
- due date 期限(NSDate)
- isDone 完了済みかどうか(0ならまだ、1なら完了済)

CategoryModelのカラムは以下のとおり
- id プライマリーキー(Int)
- category カテゴリーの内容(String)

## Create データの作成
以下のコードでデータベースにデータを作成できます
```
 // 保存するためのデータを作成する。今回はToDoModel
 let todo = ToDoModel()
 todo.todo = "hoge"

 // Realmに作成したデータを保存
 let realm = try Realm()
 try realm.write {
   realm.add(todo)
 }
```

本プロジェクトでは、ToDoModelとCategoryModelそれぞれのクラスに保存するための```create()```と```save()```で保存するデータの作成と作成したデータの保存をそれぞれ行います。

```
// ToDoModelのcreateとsave
static func create(content: String, category: CategoryModel, dueDate: NSDate) -> ToDoModel {

    let todo = ToDoModel()
    todo.todo = content
    todo.category = category
    todo.due_date = dueDate
    todo.isDone = 0
    todo.id = lastId()

    return todo
}

func save() {
    try! ToDoModel.realm.write {
        ToDoModel.realm.add(self)
    }
}
```

```
// CategoryModelのcreateとsave
static func create(newCategory text: String) -> CategoryModel {

    let category = CategoryModel()
    category.id = lastId()
    category.category = text

    return category
}

func save() {

    try! CategoryModel.realm.write{
        CategoryModel.realm.add(self)
    }
}
```

## Read データの取得

## Update データの更新

## Delete データの削除
