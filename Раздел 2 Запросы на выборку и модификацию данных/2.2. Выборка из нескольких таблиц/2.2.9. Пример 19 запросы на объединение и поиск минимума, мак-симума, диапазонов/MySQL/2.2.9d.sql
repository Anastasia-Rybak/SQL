-- Задача 2.2.9.d{140}: показать первую книгу, которую каждый из читателей взял в библиотеке.
SELECT `s_id`, `s_name`, `b_name` FROM 
(SELECT `subscriptions`.s_id, `sb_start`, `sb_id`, `subscriptions`.b_id, 
( CASE WHEN ( @sb_subscriber_value = `subscriptions`.s_id ) THEN @i := @i + 1 ELSE ( @i := 1 ) AND ( @sb_subscriber_value := `subscriptions`.s_id ) END ) AS `rank_by_subscriber`, 
( CASE WHEN ( @sb_subscriber_value = `subscriptions`.s_id ) AND ( @sb_start_value = `sb_start` ) THEN @j := @j + 1 ELSE ( @j := 1 ) AND ( @sb_subscriber_value := `subscriptions`.s_id ) AND ( @sb_start_value := `sb_start` ) END ) AS `rank_by_date` FROM `subscriptions`, 
(SELECT @i := 0, @j := 0, @sb_subscriber_value := '', @sb_start_value := '' ) AS `initialisation` ORDER BY `subscriptions`.s_id, `sb_start`, `sb_id`) AS `ranked` 
JOIN `subscribers` ON `subscriptions`.s_id = subscribers.`s_id` JOIN `books` ON `subscriptions`.b_id = `b_id` WHERE `rank_by_subscriber` = 1 AND `rank_by_date` = 1