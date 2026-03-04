-- Task Structure Database Specification
-- .tsk ファイル形式のデータベーススキーマ定義
-- 各種タスク管理手法（タスクシュート、GTD、ポモドーロ、カンバン、アイゼンハワーマトリクス等）を参考に設計
-- 対応ツール: Google Tasks, Microsoft To Do, TickTick, Todoist, TaskChute, Notion, Asana, Trello 等

-- =============================================
-- プロジェクトテーブル
-- GTD・タスクシュートのプロジェクト概念に対応
-- Google Tasks: tasklist, MS Todo: todoTaskList, TickTick: project, Todoist: project
-- =============================================
CREATE TABLE projects (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL,               -- プロジェクト名（リスト名）(Google Tasks: title, MS Todo: displayName, TickTick: name, Todoist: name)
    description TEXT,                           -- 説明
    color       TEXT,                           -- 表示色 (例: "#FF5733") (TickTick: color, Todoist: color)
    sort_order  INTEGER NOT NULL DEFAULT 0,     -- 並び順 (MS Todo: displayOrder, Todoist: order, TickTick: sortOrder)
    is_archived BOOLEAN NOT NULL DEFAULT 0,     -- アーカイブ済みフラグ (Todoist: is_archived, TickTick: closed)
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- セクションテーブル
-- Todoist のセクション、TickTick のプロジェクト内カラムに対応
-- Todoist: section, TickTick: column (projectId 配下)
-- =============================================
CREATE TABLE sections (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL,               -- セクション名 (Todoist: name, TickTick: name)
    project_id  INTEGER REFERENCES projects(id) ON DELETE CASCADE,
                                                -- 所属プロジェクト (Todoist: project_id, TickTick: projectId)
    sort_order  INTEGER NOT NULL DEFAULT 0,     -- 並び順 (Todoist: order, TickTick: sortOrder)
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- コンテキスト／モードテーブル
-- タスクシュートの「モード」、GTDの「コンテキスト（@場所/@ツール）」に対応
-- =============================================
CREATE TABLE contexts (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL,               -- コンテキスト名 (例: "@PC", "@外出先", "集中モード")
    description TEXT,                           -- 説明
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- タスクテーブル（メインテーブル）
-- 各行が1つのタスクに対応
-- =============================================
CREATE TABLE tasks (
    -- 基本識別子
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,

    -- 基本情報
    title               TEXT    NOT NULL,       -- タスク名（必須）(Google Tasks: title, MS Todo: title, TickTick: title, Todoist: content)
    description         TEXT,                   -- 詳細メモ・説明 (Google Tasks: notes, MS Todo: body, TickTick: content, Todoist: description)

    -- タスクシュート: スケジュール・時間管理
    scheduled_date      DATE,                   -- 実施予定日 (タスクシュート: 実施日, TickTick: startDate)
    start_time          DATETIME,               -- 実際の開始時刻 (タスクシュート: 開始時刻, TickTick: startDate+time)
    end_time            DATETIME,               -- 実際の終了時刻 (タスクシュート: 終了時刻, TickTick: dueDate+time)
    estimated_minutes   INTEGER,                -- 見積もり時間（分）(タスクシュート: 予定時間)
    actual_minutes      INTEGER,                -- 実績時間（分）(タスクシュート: 実績時間)

    -- タスクシュート: ルーティン管理
    is_routine          BOOLEAN NOT NULL DEFAULT 0,     -- ルーティンタスクかどうか (タスクシュート固有)
    routine_pattern     TEXT,                           -- 繰り返しパターン (例: "DAILY", "WEEKLY:MON,WED", "MONTHLY:1") (タスクシュート固有)
    recurrence_rule     TEXT,                           -- iCalendar RRULE形式の繰り返しルール (Google Tasks: recurrence, MS Todo: recurrence, TickTick: repeatFlag)

    -- GTD: 完了・ステータス管理
    status              TEXT    NOT NULL DEFAULT 'inbox'
                        CHECK(status IN (
                            'inbox',        -- 未整理（GTD インボックス）
                            'next_action',  -- 次のアクション（GTD）
                            'waiting',      -- 待機中（GTD 誰かを待っている）
                            'someday',      -- いつかやる（GTD someday/maybe）
                            'in_progress',  -- 進行中（カンバン）
                            'done',         -- 完了
                            'cancelled'     -- キャンセル
                        )),
                        -- (Google Tasks: status, MS Todo: status, TickTick: status)
    is_completed        BOOLEAN NOT NULL DEFAULT 0,     -- 完了フラグ (Google Tasks: status=completed, MS Todo: status=completed, TickTick: status=2, Todoist: is_completed)
    completed_at        DATETIME,                       -- 完了日時 (Google Tasks: completed, MS Todo: completedDateTime, TickTick: completedTime, Todoist: completed_at)

    -- カンバン: ボード列管理
    board_column        TEXT,                           -- カンバンのカラム名 (例: "Backlog", "Todo", "In Progress", "Review", "Done")
    board_order         INTEGER,                        -- カラム内の並び順

    -- アイゼンハワーマトリクス: 優先度
    is_urgent           BOOLEAN NOT NULL DEFAULT 0,     -- 緊急かどうか (アイゼンハワーマトリクス固有)
    is_important        BOOLEAN NOT NULL DEFAULT 0,     -- 重要かどうか (アイゼンハワーマトリクス固有, MS Todo: importance=high のとき true)
    priority            INTEGER NOT NULL DEFAULT 3
                        CHECK(priority BETWEEN 1 AND 5),-- 優先度 1(最高)〜5(最低) (MS Todo: importance, TickTick: priority, Todoist: priority)

    -- ポモドーロテクニック
    pomodoro_count      INTEGER NOT NULL DEFAULT 0,     -- 消費したポモドーロ数（実績）
    pomodoro_estimate   INTEGER,                        -- 見積もりポモドーロ数

    -- GTD・タスクシュート: エネルギー・集中度
    energy_level        TEXT
                        CHECK(energy_level IN ('high', 'medium', 'low', NULL)),
                                                        -- 必要エネルギーレベル

    -- 期限管理
    due_date            DATE,                           -- 締切日（日付のみ）(Google Tasks: due の日付部分, MS Todo: dueDateTime の日付部分, TickTick: dueDate, Todoist: due.date)
    due_datetime        DATETIME,                       -- 締切日時（時刻付き）(Google Tasks: due, MS Todo: dueDateTime, TickTick: dueDate, Todoist: due.datetime)
    due_string          TEXT,                           -- 自然言語形式の期限 (例: "tomorrow", "next Monday") (Todoist: due.string)
    is_all_day          BOOLEAN NOT NULL DEFAULT 0,     -- 終日フラグ (TickTick: isAllDay)
    timezone            TEXT,                           -- タイムゾーン (例: "Asia/Tokyo") (TickTick: timeZone, Google Tasks: タイムゾーン)
    reminder_at         DATETIME,                       -- リマインダー日時 (MS Todo: reminderDateTime, TickTick: reminders[0], Todoist: reminders)

    -- 関連付け
    project_id          INTEGER REFERENCES projects(id) ON DELETE SET NULL,
                                                        -- プロジェクト／リスト (Google Tasks: tasklist id, MS Todo: todoTaskList id, TickTick: projectId, Todoist: project_id)
    section_id          INTEGER REFERENCES sections(id) ON DELETE SET NULL,
                                                        -- セクション (Todoist: section_id, TickTick: columnId)
    context_id          INTEGER REFERENCES contexts(id) ON DELETE SET NULL,
                                                        -- コンテキスト／モード (GTD: @場所/@ツール, タスクシュート: モード)
    parent_task_id      INTEGER REFERENCES tasks(id) ON DELETE SET NULL,
                                                        -- 親タスク（サブタスク対応）(Google Tasks: parent, TickTick: parentId, Todoist: parent_id)

    -- チェックリスト・サブタスク情報
    checklist_total     INTEGER NOT NULL DEFAULT 0,     -- チェックリスト項目数
    checklist_done      INTEGER NOT NULL DEFAULT 0,     -- 完了済みチェックリスト項目数

    -- タグ（カンマ区切りで複数保存、または別テーブルで管理）
    tags                TEXT,                           -- タグ (TickTick: tags, Todoist: labels) (カンマ区切り, 例: "仕事,会議,重要")

    -- ファイル添付・リンク
    url                 TEXT,                           -- 関連URL
    attachment_path     TEXT,                           -- 添付ファイルパス

    -- メタデータ
    assignee            TEXT,                           -- 担当者 (Todoist: assignee_id, TickTick: assignee)
    sort_order          INTEGER,                        -- 汎用並び順 (Google Tasks: position, MS Todo: displayOrder, TickTick: sortOrder, Todoist: order)
    external_id         TEXT,                           -- 元ツールのタスクID（インポート・エクスポート時の参照用）(各ツール共通: id)
    source_tool         TEXT,                           -- 作成元ツール (例: "TaskChute", "Todoist", "Notion")
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- タスクログテーブル
-- タスクシュートの「実績ログ」に対応（同一タスクを複数回実施した記録）
-- =============================================
CREATE TABLE task_logs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id         INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    log_date        DATE    NOT NULL,           -- 実施日
    start_time      DATETIME,                   -- 開始時刻
    end_time        DATETIME,                   -- 終了時刻
    actual_minutes  INTEGER,                    -- 実績時間（分）
    note            TEXT,                       -- メモ
    mood            TEXT
                    CHECK(mood IN ('great', 'good', 'neutral', 'bad', 'terrible', NULL)),
                                                -- 実施時の気分・コンディション
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- タグテーブル（正規化版）
-- =============================================
CREATE TABLE tags (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT NOT NULL UNIQUE             -- タグ名
);

CREATE TABLE task_tags (
    task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    tag_id  INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);

-- =============================================
-- インデックス
-- =============================================
CREATE INDEX idx_tasks_scheduled_date  ON tasks(scheduled_date);
CREATE INDEX idx_tasks_due_date        ON tasks(due_date);
CREATE INDEX idx_tasks_status          ON tasks(status);
CREATE INDEX idx_tasks_project_id      ON tasks(project_id);
CREATE INDEX idx_tasks_section_id      ON tasks(section_id);
CREATE INDEX idx_tasks_parent_task_id  ON tasks(parent_task_id);
CREATE INDEX idx_tasks_external_id     ON tasks(external_id);
CREATE INDEX idx_task_logs_task_id     ON task_logs(task_id);
CREATE INDEX idx_task_logs_log_date    ON task_logs(log_date);
