DROP TABLE IF EXISTS `wp_commentmeta`;

CREATE TABLE `wp_commentmeta` (
  `meta_id` bigint(20) unsigned NOT NULL,
  `comment_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`meta_id`),
  KEY `comment_id` (`comment_id`),
  KEY `meta_key` (`meta_key`)
);


--
-- Table structure for table `wp_comments`
--

DROP TABLE IF EXISTS `wp_comments`;

CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT '0',
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT '0',
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT '',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_ID`),
  KEY `comment_approved` (`comment_approved`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`)
);


--
-- Table structure for table `wp_ec3_schedule`
--

DROP TABLE IF EXISTS `wp_ec3_schedule`;

CREATE TABLE `wp_ec3_schedule` (
  `sched_id` bigint(20) NOT NULL,
  `post_id` bigint(20) DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `allday` tinyint(1) DEFAULT NULL,
  `rpt` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`sched_id`)
);


--
-- Table structure for table `wp_links`
--

DROP TABLE IF EXISTS `wp_links`;

CREATE TABLE `wp_links` (
  `link_id` bigint(20) unsigned NOT NULL,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` bigint(20) unsigned NOT NULL DEFAULT '1',
  `link_rating` int(11) NOT NULL DEFAULT '0',
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_visible`)
);


--
-- Table structure for table `wp_options`
--

DROP TABLE IF EXISTS `wp_options`;

CREATE TABLE `wp_options` (
  `option_id` bigint(20) unsigned NOT NULL,
  `blog_id` int(11) NOT NULL DEFAULT '0',
  `option_name` varchar(64) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`)
);


--
-- Table structure for table `wp_postmeta`
--

DROP TABLE IF EXISTS `wp_postmeta`;

CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`)
);


--
-- Table structure for table `wp_posts`
--

DROP TABLE IF EXISTS `wp_posts`;

CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(20) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` text NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
);


--
-- Table structure for table `wp_term_relationships`
--

DROP TABLE IF EXISTS `wp_term_relationships`;

CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `term_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
);


--
-- Table structure for table `wp_term_taxonomy`
--

DROP TABLE IF EXISTS `wp_term_taxonomy`;

CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) unsigned NOT NULL,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`),
  KEY `taxonomy` (`taxonomy`)
);


--
-- Table structure for table `wp_terms`
--

DROP TABLE IF EXISTS `wp_terms`;

CREATE TABLE `wp_terms` (
  `term_id` bigint(20) unsigned NOT NULL,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `name` (`name`)
);


--
-- Table structure for table `wp_usermeta`
--

DROP TABLE IF EXISTS `wp_usermeta`;

CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`)
);

--
-- Table structure for table `wp_users`
--

DROP TABLE IF EXISTS `wp_users`;

CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(64) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(60) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`)
);

-- Relations (foreign keys)
SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `wp_comments`
  ADD CONSTRAINT `fk_wp_comments_post` FOREIGN KEY (`comment_post_ID`) REFERENCES `wp_posts`(`ID`) ON DELETE CASCADE;

ALTER TABLE `wp_commentmeta`
  ADD CONSTRAINT `fk_wp_commentmeta_comment` FOREIGN KEY (`comment_id`) REFERENCES `wp_comments`(`comment_ID`) ON DELETE CASCADE;

ALTER TABLE `wp_postmeta`
  ADD CONSTRAINT `fk_wp_postmeta_post` FOREIGN KEY (`post_id`) REFERENCES `wp_posts`(`ID`) ON DELETE CASCADE;

ALTER TABLE `wp_posts`
  ADD CONSTRAINT `fk_wp_posts_author` FOREIGN KEY (`post_author`) REFERENCES `wp_users`(`ID`) ON DELETE RESTRICT;

ALTER TABLE `wp_links`
  ADD CONSTRAINT `fk_wp_links_owner` FOREIGN KEY (`link_owner`) REFERENCES `wp_users`(`ID`) ON DELETE RESTRICT;

ALTER TABLE `wp_usermeta`
  ADD CONSTRAINT `fk_wp_usermeta_user` FOREIGN KEY (`user_id`) REFERENCES `wp_users`(`ID`) ON DELETE CASCADE;

ALTER TABLE `wp_term_taxonomy`
  ADD CONSTRAINT `fk_wp_term_taxonomy_term` FOREIGN KEY (`term_id`) REFERENCES `wp_terms`(`term_id`) ON DELETE RESTRICT;

ALTER TABLE `wp_term_relationships`
  ADD CONSTRAINT `fk_wp_tr_term_taxonomy` FOREIGN KEY (`term_taxonomy_id`) REFERENCES `wp_term_taxonomy`(`term_taxonomy_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_wp_tr_object_post` FOREIGN KEY (`object_id`) REFERENCES `wp_posts`(`ID`) ON DELETE CASCADE;

ALTER TABLE `wp_ec3_schedule`
  ADD CONSTRAINT `fk_wp_ec3_schedule_post` FOREIGN KEY (`post_id`) REFERENCES `wp_posts`(`ID`) ON DELETE SET NULL;

SET FOREIGN_KEY_CHECKS = 1;

-- Triggers for ID generation and derived data maintenance
DELIMITER $$

CREATE TRIGGER `trg_wp_users_set_id` BEFORE INSERT ON `wp_users`
FOR EACH ROW BEGIN
  IF NEW.`ID` IS NULL OR NEW.`ID` = 0 THEN
    SET NEW.`ID` = (SELECT IFNULL(MAX(u.`ID`), 0) + 1 FROM `wp_users` u);
  END IF;
  IF NEW.`user_nicename` IS NULL OR NEW.`user_nicename` = '' THEN
    SET NEW.`user_nicename` = LOWER(REPLACE(NEW.`user_login`, ' ', '-'));
  END IF;
END $$

CREATE TRIGGER `trg_wp_posts_set_id` BEFORE INSERT ON `wp_posts`
FOR EACH ROW BEGIN
  IF NEW.`ID` IS NULL OR NEW.`ID` = 0 THEN
    SET NEW.`ID` = (SELECT IFNULL(MAX(p.`ID`), 0) + 1 FROM `wp_posts` p);
  END IF;
END $$

CREATE TRIGGER `trg_wp_comments_set_id` BEFORE INSERT ON `wp_comments`
FOR EACH ROW BEGIN
  IF NEW.`comment_ID` IS NULL OR NEW.`comment_ID` = 0 THEN
    SET NEW.`comment_ID` = (SELECT IFNULL(MAX(c.`comment_ID`), 0) + 1 FROM `wp_comments` c);
  END IF;
END $$

CREATE TRIGGER `trg_wp_terms_set_id` BEFORE INSERT ON `wp_terms`
FOR EACH ROW BEGIN
  IF NEW.`term_id` IS NULL OR NEW.`term_id` = 0 THEN
    SET NEW.`term_id` = (SELECT IFNULL(MAX(t.`term_id`), 0) + 1 FROM `wp_terms` t);
  END IF;
END $$

CREATE TRIGGER `trg_wp_term_taxonomy_set_id` BEFORE INSERT ON `wp_term_taxonomy`
FOR EACH ROW BEGIN
  IF NEW.`term_taxonomy_id` IS NULL OR NEW.`term_taxonomy_id` = 0 THEN
    SET NEW.`term_taxonomy_id` = (SELECT IFNULL(MAX(tt.`term_taxonomy_id`), 0) + 1 FROM `wp_term_taxonomy` tt);
  END IF;
END $$

CREATE TRIGGER `trg_wp_links_set_id` BEFORE INSERT ON `wp_links`
FOR EACH ROW BEGIN
  IF NEW.`link_id` IS NULL OR NEW.`link_id` = 0 THEN
    SET NEW.`link_id` = (SELECT IFNULL(MAX(l.`link_id`), 0) + 1 FROM `wp_links` l);
  END IF;
END $$

CREATE TRIGGER `trg_wp_options_set_id` BEFORE INSERT ON `wp_options`
FOR EACH ROW BEGIN
  IF NEW.`option_id` IS NULL OR NEW.`option_id` = 0 THEN
    SET NEW.`option_id` = (SELECT IFNULL(MAX(o.`option_id`), 0) + 1 FROM `wp_options` o);
  END IF;
END $$

CREATE TRIGGER `trg_wp_postmeta_set_id` BEFORE INSERT ON `wp_postmeta`
FOR EACH ROW BEGIN
  IF NEW.`meta_id` IS NULL OR NEW.`meta_id` = 0 THEN
    SET NEW.`meta_id` = (SELECT IFNULL(MAX(pm.`meta_id`), 0) + 1 FROM `wp_postmeta` pm);
  END IF;
END $$

CREATE TRIGGER `trg_wp_commentmeta_set_id` BEFORE INSERT ON `wp_commentmeta`
FOR EACH ROW BEGIN
  IF NEW.`meta_id` IS NULL OR NEW.`meta_id` = 0 THEN
    SET NEW.`meta_id` = (SELECT IFNULL(MAX(cm.`meta_id`), 0) + 1 FROM `wp_commentmeta` cm);
  END IF;
END $$

CREATE TRIGGER `trg_wp_usermeta_set_id` BEFORE INSERT ON `wp_usermeta`
FOR EACH ROW BEGIN
  IF NEW.`umeta_id` IS NULL OR NEW.`umeta_id` = 0 THEN
    SET NEW.`umeta_id` = (SELECT IFNULL(MAX(um.`umeta_id`), 0) + 1 FROM `wp_usermeta` um);
  END IF;
END $$

CREATE TRIGGER `trg_wp_ec3_schedule_set_id` BEFORE INSERT ON `wp_ec3_schedule`
FOR EACH ROW BEGIN
  IF NEW.`sched_id` IS NULL OR NEW.`sched_id` = 0 THEN
    SET NEW.`sched_id` = (SELECT IFNULL(MAX(s.`sched_id`), 0) + 1 FROM `wp_ec3_schedule` s);
  END IF;
END $$

-- Maintain comment_count on posts
CREATE TRIGGER `trg_wp_comments_ai_update_post_count` AFTER INSERT ON `wp_comments`
FOR EACH ROW BEGIN
  UPDATE `wp_posts` SET `comment_count` = `comment_count` + 1 WHERE `ID` = NEW.`comment_post_ID`;
END $$

CREATE TRIGGER `trg_wp_comments_ad_update_post_count` AFTER DELETE ON `wp_comments`
FOR EACH ROW BEGIN
  UPDATE `wp_posts` SET `comment_count` = CASE WHEN `comment_count` > 0 THEN `comment_count` - 1 ELSE 0 END WHERE `ID` = OLD.`comment_post_ID`;
END $$

-- Maintain term_taxonomy.count based on relationships
CREATE TRIGGER `trg_wp_tr_ai_update_tt_count` AFTER INSERT ON `wp_term_relationships`
FOR EACH ROW BEGIN
  UPDATE `wp_term_taxonomy` SET `count` = `count` + 1 WHERE `term_taxonomy_id` = NEW.`term_taxonomy_id`;
END $$

CREATE TRIGGER `trg_wp_tr_ad_update_tt_count` AFTER DELETE ON `wp_term_relationships`
FOR EACH ROW BEGIN
  UPDATE `wp_term_taxonomy` SET `count` = CASE WHEN `count` > 0 THEN `count` - 1 ELSE 0 END WHERE `term_taxonomy_id` = OLD.`term_taxonomy_id`;
END $$

DELIMITER ;