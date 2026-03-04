-- サンプルデータ
-- 各種タスク管理手法を反映したタスクのサンプル行

-- プロジェクトデータ
INSERT INTO projects (name, description, color, sort_order) VALUES
    ('仕事', '業務関連タスク全般', '#4A90E2', 1),
    ('個人開発', 'サイドプロジェクト・学習', '#7ED321', 2),
    ('健康', '運動・食事・睡眠管理', '#F5A623', 3),
    ('家事', '家庭内タスク', '#9B59B6', 4);

-- セクションデータ（Todoist セクション / TickTick カラム）
INSERT INTO sections (name, project_id, sort_order) VALUES
    ('今週', 1, 1),
    ('来週以降', 1, 2),
    ('設計', 2, 1),
    ('実装', 2, 2),
    ('テスト', 2, 3);

-- コンテキストデータ
INSERT INTO contexts (name, description) VALUES
    ('@PC',       'PCが必要な作業'),
    ('@電話',     '電話が必要な作業'),
    ('@外出先',   '外出中にできる作業'),
    ('@自宅',     '自宅でできる作業'),
    ('集中モード','深い集中が必要な作業'),
    ('隙間時間',  '短い空き時間でできる作業');

-- タグデータ
INSERT INTO tags (name) VALUES
    ('会議'), ('レポート'), ('メール'), ('コーディング'),
    ('レビュー'), ('学習'), ('運動'), ('買い物');

-- =============================================
-- タスクサンプルデータ
-- 各種タスク管理手法のシナリオを網羅
-- =============================================

-- 1. タスクシュート式: 今日のルーティンタスク（朝の準備）
INSERT INTO tasks (
    title, description,
    scheduled_date, start_time, end_time,
    estimated_minutes, actual_minutes,
    is_routine, routine_pattern,
    status, is_completed, completed_at,
    priority, energy_level,
    project_id, context_id,
    source_tool
) VALUES (
    '朝のルーティン（ストレッチ・日記）',
    '起床後10分間のストレッチと昨日の振り返り日記',
    '2026-03-04', '2026-03-04 07:00:00', '2026-03-04 07:20:00',
    20, 20,
    1, 'DAILY',
    'done', 1, '2026-03-04 07:20:00',
    2, 'low',
    3, 4,
    'TaskChute'
);

-- 2. タスクシュート式: 見積もりと実績が異なったタスク
INSERT INTO tasks (
    title, description,
    scheduled_date, start_time, end_time,
    estimated_minutes, actual_minutes,
    is_routine, status, is_completed, completed_at,
    priority, energy_level,
    project_id, context_id,
    tags, source_tool
) VALUES (
    '週次報告書の作成',
    '先週の進捗・課題・来週の計画をまとめる',
    '2026-03-04', '2026-03-04 09:00:00', '2026-03-04 10:15:00',
    60, 75,
    0, 'done', 1, '2026-03-04 10:15:00',
    2, 'high',
    1, 1,
    'レポート,仕事', 'TaskChute'
);

-- 3. GTD式: インボックスに溜まったタスク（未整理）
INSERT INTO tasks (
    title, description,
    status, is_completed,
    priority,
    source_tool
) VALUES (
    '税務署に提出する書類を確認する',
    '確定申告に必要な書類リストをチェックする',
    'inbox', 0,
    3,
    'GTD'
);

-- 4. GTD式: 次のアクション
INSERT INTO tasks (
    title, description,
    scheduled_date,
    estimated_minutes,
    status, is_completed,
    priority, energy_level,
    context_id,
    source_tool
) VALUES (
    'プロジェクトAのキックオフ資料を送付',
    '先方に送るキックオフMTG用のアジェンダと資料をメールで送る',
    '2026-03-04',
    15,
    'next_action', 0,
    1, 'medium',
    1,
    'GTD'
);

-- 5. GTD式: 誰かを待っているタスク
INSERT INTO tasks (
    title, description,
    due_date,
    status, is_completed,
    priority,
    project_id,
    source_tool
) VALUES (
    '田中さんからの見積もり回答を待つ',
    'ベンダーに見積もり依頼済み。2026-03-10までに回答予定',
    '2026-03-10',
    'waiting', 0,
    2,
    1,
    'GTD'
);

-- 6. GTD式: いつかやりたいタスク
INSERT INTO tasks (
    title, description,
    status, is_completed,
    priority, energy_level,
    project_id,
    source_tool
) VALUES (
    'Rustプログラミング言語を学ぶ',
    'システムプログラミング向けにRustの基礎を学習する',
    'someday', 0,
    4, 'high',
    2,
    'GTD'
);

-- 7. カンバン式: 進行中タスク（ボード列あり）
INSERT INTO tasks (
    title, description,
    status, is_completed,
    board_column, board_order,
    priority, energy_level,
    project_id, context_id,
    pomodoro_estimate, pomodoro_count,
    tags, source_tool
) VALUES (
    'ユーザー認証機能の実装',
    'JWT を使ったログイン・ログアウト・トークン更新APIの実装',
    'in_progress', 0,
    'In Progress', 1,
    1, 'high',
    2, 5,
    4, 2,
    'コーディング,レビュー', 'Trello'
);

-- 8. カンバン式: バックログのタスク
INSERT INTO tasks (
    title, description,
    due_date,
    status, is_completed,
    board_column, board_order,
    priority,
    project_id,
    checklist_total, checklist_done,
    source_tool
) VALUES (
    'データベース設計書の作成',
    'ERD・テーブル定義書・インデックス設計をまとめる',
    '2026-03-20',
    'next_action', 0,
    'Backlog', 3,
    2,
    2,
    5, 1,
    'Notion'
);

-- 9. アイゼンハワーマトリクス: 緊急かつ重要（第1象限）
INSERT INTO tasks (
    title, description,
    due_date, reminder_at,
    status, is_completed,
    is_urgent, is_important,
    priority, energy_level,
    project_id, context_id,
    source_tool
) VALUES (
    'サーバー障害の対応',
    '本番環境でエラーが発生。ログを確認して原因を特定・修正する',
    '2026-03-04', '2026-03-04 08:00:00',
    'in_progress', 0,
    1, 1,
    1, 'high',
    1, 5,
    'Todoist'
);

-- 10. アイゼンハワーマトリクス: 緊急でないが重要（第2象限）
INSERT INTO tasks (
    title, description,
    due_date,
    status, is_completed,
    is_urgent, is_important,
    priority, energy_level,
    project_id, context_id,
    estimated_minutes,
    source_tool
) VALUES (
    '中長期キャリアプランの策定',
    '3年後・5年後のキャリア目標と具体的なアクションプランを文書化する',
    '2026-04-01',
    'next_action', 0,
    0, 1,
    2, 'high',
    2, 4,
    120,
    'Notion'
);

-- 11. アイゼンハワーマトリクス: 緊急だが重要でない（第3象限・委任候補）
INSERT INTO tasks (
    title, description,
    due_date,
    status, is_completed,
    is_urgent, is_important,
    priority,
    context_id,
    estimated_minutes,
    source_tool
) VALUES (
    '会議室の予約確認メール返信',
    '総務からの会議室予約確認メールに返信する',
    '2026-03-04',
    'next_action', 0,
    1, 0,
    3,
    2,
    5,
    'メール返信ツール'
);

-- 12. ポモドーロテクニック式: ポモドーロで時間管理したタスク
INSERT INTO tasks (
    title, description,
    scheduled_date,
    estimated_minutes, actual_minutes,
    is_routine,
    status, is_completed, completed_at,
    pomodoro_estimate, pomodoro_count,
    priority, energy_level,
    project_id, context_id,
    tags, source_tool
) VALUES (
    '技術ブログ記事の執筆',
    'Rustの所有権システムについて分かりやすく解説する記事を書く',
    '2026-03-04',
    100, 100,
    0,
    'done', 1, '2026-03-04 16:40:00',
    4, 4,
    2, 'high',
    2, 5,
    'コーディング,学習', 'ポモドーロタイマー'
);

-- 13. サブタスク（親タスクあり）
INSERT INTO tasks (
    title, description,
    scheduled_date,
    status, is_completed,
    priority,
    project_id,
    source_tool
) VALUES (
    'チームビルディングイベントの企画',
    'Q2のチームビルディング全体計画',
    '2026-03-31',
    'in_progress', 0,
    2,
    1,
    'Asana'
);

-- サブタスク（parent_task_id = 13 を想定）
INSERT INTO tasks (
    title, description,
    due_date,
    status, is_completed,
    priority,
    project_id,
    parent_task_id,
    source_tool
) VALUES
    ('会場候補のリストアップ', '3〜5箇所の会場を選定する', '2026-03-10', 'done', 1, 2, 1, 13, 'Asana'),
    ('参加者アンケートの作成', '希望日程・アクティビティを聞くフォームを作る', '2026-03-12', 'next_action', 0, 2, 1, 13, 'Asana'),
    ('予算申請書の提出', '経費精算・予算申請を経理部に提出', '2026-03-15', 'next_action', 0, 1, 1, 13, 'Asana');

-- タスクとタグの紐付け
INSERT INTO task_tags (task_id, tag_id)
SELECT t.id, tg.id FROM tasks t, tags tg
WHERE t.title = '週次報告書の作成' AND tg.name IN ('レポート', '会議');

INSERT INTO task_tags (task_id, tag_id)
SELECT t.id, tg.id FROM tasks t, tags tg
WHERE t.title = 'ユーザー認証機能の実装' AND tg.name IN ('コーディング', 'レビュー');

INSERT INTO task_tags (task_id, tag_id)
SELECT t.id, tg.id FROM tasks t, tags tg
WHERE t.title = '技術ブログ記事の執筆' AND tg.name IN ('コーディング', '学習');

-- =============================================
-- タスクログサンプル（タスクシュート式の実績記録）
-- =============================================

-- 朝のルーティンの過去3日分ログ
INSERT INTO task_logs (task_id, log_date, start_time, end_time, actual_minutes, note, mood)
SELECT t.id, '2026-03-01', '2026-03-01 07:05:00', '2026-03-01 07:22:00', 17, '少し時間を節約できた', 'good'
FROM tasks t WHERE t.title = '朝のルーティン（ストレッチ・日記）';

INSERT INTO task_logs (task_id, log_date, start_time, end_time, actual_minutes, note, mood)
SELECT t.id, '2026-03-02', '2026-03-02 07:10:00', '2026-03-02 07:35:00', 25, '日記に時間がかかった', 'neutral'
FROM tasks t WHERE t.title = '朝のルーティン（ストレッチ・日記）';

INSERT INTO task_logs (task_id, log_date, start_time, end_time, actual_minutes, note, mood)
SELECT t.id, '2026-03-03', '2026-03-03 07:00:00', '2026-03-03 07:20:00', 20, 'いいペース', 'great'
FROM tasks t WHERE t.title = '朝のルーティン（ストレッチ・日記）';

-- =============================================
-- 主要ツール対応サンプルデータ
-- =============================================

-- Google Tasks: 締切日時付きタスク（due_datetime, is_all_day, timezone, external_id）
INSERT INTO tasks (
    title, description,
    due_date, due_datetime, is_all_day, timezone,
    status, is_completed,
    priority,
    project_id,
    sort_order, external_id, source_tool
) VALUES (
    '健康診断の予約',
    '4月の健康診断を病院のウェブサイトから予約する',
    '2026-04-10', '2026-04-10 10:00:00', 0, 'Asia/Tokyo',
    'next_action', 0,
    2,
    3,
    1, 'google-task-abc123', 'Google Tasks'
);

-- Google Tasks: 終日タスク（繰り返しルール付き）
INSERT INTO tasks (
    title, description,
    due_date, is_all_day, timezone,
    is_routine, recurrence_rule,
    status, is_completed,
    priority,
    project_id,
    sort_order, external_id, source_tool
) VALUES (
    '週次レビュー',
    '毎週金曜日に今週の振り返りと来週の計画を立てる',
    '2026-03-07', 1, 'Asia/Tokyo',
    1, 'RRULE:FREQ=WEEKLY;BYDAY=FR',
    'next_action', 0,
    2,
    1,
    2, 'google-task-def456', 'Google Tasks'
);

-- Microsoft To Do: 重要フラグ・繰り返し・リマインダー付きタスク
INSERT INTO tasks (
    title, description,
    due_date, due_datetime, reminder_at,
    is_routine, recurrence_rule,
    status, is_completed,
    is_important,
    priority,
    project_id,
    sort_order, external_id, source_tool
) VALUES (
    '家賃の支払い',
    '毎月1日に口座振替を確認する',
    '2026-04-01', '2026-04-01 09:00:00', '2026-03-31 09:00:00',
    1, 'RRULE:FREQ=MONTHLY;BYMONTHDAY=1',
    'next_action', 0,
    1,
    1,
    4,
    3, 'mstodo-task-ghi789', 'Microsoft To Do'
);

-- Microsoft To Do: ステップ付きタスク（サブタスク）
INSERT INTO tasks (
    title, description,
    due_date,
    status, is_completed,
    is_important, priority,
    project_id,
    checklist_total, checklist_done,
    sort_order, external_id, source_tool
) VALUES (
    '引越し準備',
    '新居への引越しに必要なタスク一覧',
    '2026-05-01',
    'in_progress', 0,
    1, 2,
    4,
    5, 1,
    1, 'mstodo-task-jkl012', 'Microsoft To Do'
);

-- TickTick: 時刻付き期限・タイムゾーン・終日フラグ・担当者・セクション
INSERT INTO tasks (
    title, description,
    scheduled_date, due_date, due_datetime, is_all_day, timezone,
    estimated_minutes,
    is_routine, recurrence_rule,
    status, is_completed,
    priority, energy_level,
    project_id, section_id,
    tags,
    assignee,
    sort_order, external_id, source_tool
) VALUES (
    'APIドキュメントの作成',
    'REST APIの仕様書をOpenAPI形式で作成する',
    '2026-03-05', '2026-03-07', '2026-03-07 17:00:00', 0, 'Asia/Tokyo',
    120,
    0, NULL,
    'next_action', 0,
    2, 'high',
    2, 3,
    'コーディング,ドキュメント',
    '山田太郎',
    1, 'ticktick-task-mno345', 'TickTick'
);

-- TickTick: 繰り返しタスク（隔週）
INSERT INTO tasks (
    title, description,
    due_date, due_datetime, is_all_day, timezone,
    is_routine, recurrence_rule,
    status, is_completed,
    priority,
    project_id,
    sort_order, external_id, source_tool
) VALUES (
    '隔週チームミーティング',
    '隔週火曜日のチーム定例ミーティング（30分）',
    '2026-03-10', '2026-03-10 14:00:00', 0, 'Asia/Tokyo',
    1, 'RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=TU',
    'next_action', 0,
    2,
    1,
    2, 'ticktick-task-pqr678', 'TickTick'
);

-- Todoist: セクション・担当者・自然言語期限・優先度付きタスク
INSERT INTO tasks (
    title, description,
    due_date, due_string,
    status, is_completed,
    is_urgent, is_important,
    priority,
    project_id, section_id,
    assignee,
    sort_order, external_id, source_tool
) VALUES (
    'コードレビューの実施',
    'プルリクエスト #42 をレビューしてフィードバックを送る',
    '2026-03-06', 'tomorrow',
    'next_action', 0,
    0, 1,
    1,
    2, 4,
    '鈴木花子',
    1, 'todoist-task-stu901', 'Todoist'
);

-- Todoist: ラベル・セクション・繰り返し付きタスク
INSERT INTO tasks (
    title, description,
    due_date, due_string,
    is_routine, recurrence_rule,
    status, is_completed,
    priority, energy_level,
    project_id, section_id,
    context_id,
    tags,
    sort_order, external_id, source_tool
) VALUES (
    '受信トレイの整理（GTD インボックス処理）',
    'メール・メモ・気になることを全てインボックスから処理する',
    '2026-03-07', 'every friday',
    1, 'RRULE:FREQ=WEEKLY;BYDAY=FR',
    'next_action', 0,
    3, 'low',
    1, 1,
    1,
    'メール,GTD',
    5, 'todoist-task-vwx234', 'Todoist'
);
