# Task-Structure-Database-Specification

タスクの要素、締切日などは規格化できる。これにより、ツール間移行を簡単にするためのバックアップファイルの形式を作りたい `.tsk` のような拡張子の規格である。

---

## 対応ツール

Google Tasks、Microsoft To Do、TickTick、Todoist、TaskChute、Notion、Asana、Trello など、主要タスク管理ツールの構造を統合している。

---

## テーブル構造

タスクシュート・GTD・ポモドーロテクニック・カンバン・アイゼンハワーマトリクスなど、各種タスク管理手法の概念を1つのスキーマに統合している。

### ファイル一覧

| ファイル | 説明 |
|---|---|
| [`schema.sql`](schema.sql) | テーブル定義（DDL） |
| [`sample_data.sql`](sample_data.sql) | サンプルデータ（DML） |

---

## テーブル一覧

### `tasks`（メインテーブル）

各行が1件のタスク。

| カラム | 型 | 説明 | 対応ツール／手法 |
|---|---|---|---|
| `id` | INTEGER | 主キー | 共通 |
| `title` | TEXT | タスク名（必須） | 共通 |
| `description` | TEXT | 詳細メモ | 共通 |
| `scheduled_date` | DATE | 実施予定日 | タスクシュート, TickTick |
| `start_time` | DATETIME | 実際の開始時刻 | タスクシュート |
| `end_time` | DATETIME | 実際の終了時刻 | タスクシュート |
| `estimated_minutes` | INTEGER | 見積もり時間（分） | タスクシュート・ポモドーロ |
| `actual_minutes` | INTEGER | 実績時間（分） | タスクシュート |
| `is_routine` | BOOLEAN | ルーティンタスクか | タスクシュート |
| `routine_pattern` | TEXT | 繰り返しパターン（例: `DAILY`, `WEEKLY:MON`） | タスクシュート |
| `recurrence_rule` | TEXT | iCalendar RRULE形式の繰り返しルール（例: `RRULE:FREQ=WEEKLY;BYDAY=FR`） | MS Todo, Google Tasks, TickTick |
| `status` | TEXT | ステータス（`inbox` / `next_action` / `waiting` / `someday` / `in_progress` / `done` / `cancelled`） | GTD・カンバン |
| `is_completed` | BOOLEAN | 完了フラグ | 共通 |
| `completed_at` | DATETIME | 完了日時 | 共通 |
| `board_column` | TEXT | カンバンのカラム名 | カンバン |
| `board_order` | INTEGER | カラム内の並び順 | カンバン |
| `is_urgent` | BOOLEAN | 緊急かどうか | アイゼンハワーマトリクス |
| `is_important` | BOOLEAN | 重要かどうか | アイゼンハワーマトリクス, MS Todo |
| `priority` | INTEGER | 優先度 1（最高）〜 5（最低） | 共通 |
| `pomodoro_count` | INTEGER | 消費ポモドーロ数（実績） | ポモドーロ |
| `pomodoro_estimate` | INTEGER | 見積もりポモドーロ数 | ポモドーロ |
| `energy_level` | TEXT | 必要エネルギーレベル（`high` / `medium` / `low`） | GTD・タスクシュート |
| `due_date` | DATE | 締切日（日付のみ） | 共通 |
| `due_datetime` | DATETIME | 締切日時（時刻付き） | Google Tasks, TickTick, MS Todo |
| `due_string` | TEXT | 自然言語形式の期限（例: `tomorrow`, `every friday`） | Todoist |
| `is_all_day` | BOOLEAN | 終日フラグ | TickTick |
| `timezone` | TEXT | タイムゾーン（例: `Asia/Tokyo`） | TickTick, Google Tasks |
| `reminder_at` | DATETIME | リマインダー日時 | 共通 |
| `project_id` | INTEGER | 関連プロジェクト／リスト（FKあり） | 共通 |
| `section_id` | INTEGER | セクション（FKあり） | Todoist, TickTick |
| `context_id` | INTEGER | コンテキスト／モード（FKあり） | GTD・タスクシュート |
| `parent_task_id` | INTEGER | 親タスクID（サブタスク対応） | 共通 |
| `checklist_total` | INTEGER | チェックリスト項目数 | 共通 |
| `checklist_done` | INTEGER | 完了済みチェックリスト数 | 共通 |
| `tags` | TEXT | タグ（カンマ区切り） | 共通 |
| `url` | TEXT | 関連URL | 共通 |
| `attachment_path` | TEXT | 添付ファイルパス | 共通 |
| `assignee` | TEXT | 担当者名 | Todoist, TickTick |
| `sort_order` | INTEGER | 汎用並び順 | Todoist, TickTick, MS Todo |
| `external_id` | TEXT | 元ツールのタスクID（インポート・エクスポート参照用） | 共通 |
| `source_tool` | TEXT | 作成元ツール名 | 共通 |
| `created_at` | DATETIME | 作成日時 | 共通 |
| `updated_at` | DATETIME | 更新日時 | 共通 |

### `task_logs`（タスク実績ログ）

タスクシュートの「実績ログ」に対応。同一のルーティンタスクを複数日実施した記録を蓄積する。

| カラム | 型 | 説明 |
|---|---|---|
| `id` | INTEGER | 主キー |
| `task_id` | INTEGER | 対象タスク（FK） |
| `log_date` | DATE | 実施日 |
| `start_time` | DATETIME | 開始時刻 |
| `end_time` | DATETIME | 終了時刻 |
| `actual_minutes` | INTEGER | 実績時間（分） |
| `note` | TEXT | メモ |
| `mood` | TEXT | 気分・コンディション（`great` / `good` / `neutral` / `bad` / `terrible`） |
| `created_at` | DATETIME | 記録日時 |

### `projects`（プロジェクト／リスト）

GTD・タスクシュートのプロジェクト概念、および Google Tasks・MS Todo のリスト概念に対応。

| カラム | 型 | 説明 |
|---|---|---|
| `id` | INTEGER | 主キー |
| `name` | TEXT | プロジェクト名／リスト名 |
| `description` | TEXT | 説明 |
| `color` | TEXT | 表示色 |
| `sort_order` | INTEGER | 並び順（MS Todo displayOrder, Todoist order） |
| `is_archived` | BOOLEAN | アーカイブ済みフラグ（Todoist, TickTick） |
| `created_at` | DATETIME | 作成日時 |
| `updated_at` | DATETIME | 更新日時 |

### `sections`（セクション）

Todoist のセクション、TickTick のプロジェクト内カラムに対応。

| カラム | 型 | 説明 |
|---|---|---|
| `id` | INTEGER | 主キー |
| `name` | TEXT | セクション名 |
| `project_id` | INTEGER | 所属プロジェクト（FK） |
| `sort_order` | INTEGER | 並び順 |
| `created_at` | DATETIME | 作成日時 |

### `contexts`（コンテキスト／モード）

GTD の `@場所` や `@ツール`、タスクシュートの「モード」に対応。

### `tags` / `task_tags`（タグ）

タスクへの多対多のタグ付け。`tasks.tags` カラム（カンマ区切り文字列）の正規化版。

---

## 主要ツールとカラムの対応

| カラム | Google Tasks | MS Todo | TickTick | Todoist |
|---|---|---|---|---|
| `title` | title | title | title | content |
| `description` | notes | body | content | description |
| `due_date` | due (date part) | dueDateTime (date) | dueDate | due.date |
| `due_datetime` | due (with time) | dueDateTime | dueDate (with time) | due.datetime |
| `due_string` | — | — | — | due.string |
| `is_all_day` | — | — | isAllDay | — |
| `timezone` | — | — | timeZone | — |
| `recurrence_rule` | recurrence | recurrence (RRULE) | repeatFlag | — |
| `is_important` | — | importance (high) | — | — |
| `priority` | — | importance | priority | priority |
| `status` | status | status | status | — |
| `section_id` | — | — | columnId | section_id |
| `project_id` | listId | listId | projectId | project_id |
| `parent_task_id` | parent | — | parentId | parent_id |
| `assignee` | — | — | assignee | assignee_id |
| `sort_order` | position | displayOrder | sortOrder | order |
| `external_id` | id | id | id | id |
| `reminder_at` | — | reminderDateTime | reminders[0] | reminders |
| `tags` | — | — | tags | labels |

---

## アイゼンハワーマトリクスとステータスの対応

| `is_urgent` | `is_important` | 象限 | 推奨アクション |
|---|---|---|---|
| 1（緊急） | 1（重要） | 第1象限 | 今すぐやる |
| 0（緊急でない） | 1（重要） | 第2象限 | 計画してやる |
| 1（緊急） | 0（重要でない） | 第3象限 | 委任する |
| 0（緊急でない） | 0（重要でない） | 第4象限 | やらない |

---

## サンプルデータの実行方法（SQLite）

```bash
sqlite3 tasks.db < schema.sql
sqlite3 tasks.db < sample_data.sql
sqlite3 tasks.db "SELECT id, title, status, scheduled_date, estimated_minutes FROM tasks;"
```
