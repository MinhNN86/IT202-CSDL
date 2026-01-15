DROP DATABASE IF EXISTS DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);
CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL UNIQUE ,
    user_id INT NOT NULL UNIQUE ,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username, posts_count) VALUES ('minh', 1);
INSERT INTO posts (user_id, content) VALUES
(1, 'Bài viết đầu tiên của Minh');

START TRANSACTION;
INSERT INTO likes (post_id, user_id) VALUES
(1, 1);

UPDATE posts
SET like_count = like_count + 1
WHERE post_id = 1;
COMMIT ;

START TRANSACTION;
INSERT INTO likes(post_id, user_id) VALUES
    (1,1);
UPDATE posts
SET like_count = like_count + 1
WHERE post_id = 1;
ROLLBACK;
