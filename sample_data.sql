-- サンプルデータ
-- 各種タスク管理手法を反映したタスクのサンプル行

-- プロジェクトデータ
INSERT INTO projects (name, description, color) VALUES
    ('仕事', '業務関連タスク全般', '#4A90E2'),
    ('個人開発', 'サイドプロジェクト・学習', '#7ED321'),
    ('健康', '運動・食事・睡眠管理', '#F5A623'),
    ('家事', '家庭内タスク', '#9B59B6');

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
