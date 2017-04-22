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
- カテゴリーの追加

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
```swift
 // 保存するためのデータを作成する。今回はToDoModel
 let todo = ToDoModel()
 todo.todo = "hoge"

 // Realmに作成したデータを保存
 let realm = try Realm()
 try realm.write {
   realm.add(todo)
 }
```

本プロジェクトでは、ToDoModelとCategoryModelそれぞれのクラスで保存するための```create()```と```save()```で保存するデータの作成と作成したデータの保存をそれぞれ行います。

**ToDoModel.swift**
```swift
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

**CategoryModel.swift**
```swift
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
以下のコードでデータベースからデータを取得します

```swift
let realm = try Realm()
let todos = realm.objects(ToDoModel)
```

本プロジェクトではToDoModelとCategoryModelそれぞれのクラスでデータを取得するための```loadAll()```で保存するデータ取得をそれぞれ行います。またToDoModelでは、```loadUndone()```でもデータを取得します

**ToDoModel.swift**
```swift
// ToDoModelでのデータを取得するためのメソッド
static func loadAll() -> [ToDoModel] {

    let todos = realm.objects(ToDoModel).sorted("id", ascending: true)
    var ret: [ToDoModel] = []
    for todo in todos {
        ret.append(todo)
    }
    return ret
}

static func loadUndone() -> [ToDoModel] {

    let todos = realm.objects(ToDoModel).filter("isDone = 0")
    var ret: [ToDoModel] = []
    for todo in todos {
        ret.append(todo)
    }
    return ret
}
```

**CategoryModel.swift**
```swift
// データを全件取得
static func loadAll() -> [CategoryModel] {

    let categories = realm.objects(CategoryModel).sorted("id", ascending: true)
    var array: [CategoryModel] = []
    for category in categories {
        array.append(category)
    }
    return array
}
```

## Update データの更新
以下のコードでデータベースにデータの更新を行えます。

```swift
let realm = try Realm()
try realm.write {
  // ここで変更を行う
}
```

本プロジェクトでは、ToDoModelとCategoryModelではそれぞれで更新するための```update()```でデータの更新を行います。

**ToDoModel.swift**
```swift
// ToDoModelのupdate
static func update(model: ToDoModel,content: String, category: CategoryModel, dueDate: NSDate) {

    try! realm.write({
        model.todo = content
        model.category = category
        model.due_date = dueDate
        model.isDone = 0
    })
}

```

**CategoryModel.swift**
```swift
// CategoryModelのupdate
static func update(model: CategoryModel, content: String) {

    try! realm.write {
        model.category = content
    }
}
```
## Delete データの削除

以下のコードでデータベースのデータを削除できます。

```swift
let realm = try Realm()
try! realm.write {
  realm.delete(削除するデータ)
}   
```

ToDoModelとCategoryModelでは、それぞれViewControllerとCategoryViewControllerのUITableViewにUITableViewRowActionを追加し、そこで削除しています。

**ViewControllerExtension.swift**
```swift
// ToDoModelの削除。
let item = self.realm.objects(ToDoModel)[indexPath.row]
try! self.realm.write {
    self.realm.delete(item
    )
}

```
**CategoryViewController.swift**
```swift
// CategoryModelの削除。UITableViewRowActionで呼び出すことで削除する。
func deleteModel(index id: Int) {
    try! realm.write {
        realm.delete(categories[id])
    }
}
```
