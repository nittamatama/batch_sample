# 自作バッチアプリ

## テーブル設計

### users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| id                 | string | null: false |
| name               | string | null: false |

### Association

- has_many :user_scores
- has_one :ranks


### user_scores テーブル

| Column      | Type   | Options     |
| ------      | ------ | ----------- |
| id          | string | null: false |
| user_id     |
| received_at |

### Association

- belongs_to :user

### ranks テーブル

| Column   | Type       | Options                        |
| ------   | ---------- | ------------------------------ |
| id       | references | null: false, foreign_key: true |
| user_id  | references | null: false, foreign_key: true |
| rank     |
| score    |

### Association

- belongs_to :user