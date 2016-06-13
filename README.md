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

[追加予定]
- カテゴリーごとの表示
- カテゴリ-の追加
- TODOの期限のタイミングでの通知

# CRUD

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

## Read データの取得

## Update データの更新

## Delete データの削除
