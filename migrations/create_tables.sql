CREATE TABLE IF NOT EXIST users (
    nickname    VARCHAR(255)    NOT NULL PRIMARY KEY UNIQUE,
    fullname    VARCHAR(255)    NOT NULL,
    email       VARCHAR(255)    NOT NULL UNIQUE,
    about       TEXT            NOT NULL DEFAULT ''
)



CREATE TABLE IF NOT EXIST forums (
    slug        VARCHAR(255)    NOT NULL PRIMARY KEY,
    postCount   INTEGER         NOT NULL DEFAULT 0,
    threadCount INTEGER         NOT NULL DEFAULT 0,
    title       VARCHAR(255)    NOT NULL,
    user        VARCHAR(255)    NOT NULL REFERENCES users (nickname)            
)

CREATE TABLE IF NOT EXIST threads (
    id          BIGSERIAL       NOT NULL PRIMARY KEY,
    author      VARCHAR(255)    NOT NULL REFERENCES users (nickname),
    created     DATETIME        NOT NULL,
    forum       VARCHAR(255)    NOT NULL REFERENCES forums (slug)
    messageText TEXT            NOT NULL,
    slug        VARCHAR(255)    NOT NULL UNIQUE,
    title       TEXT            NOT NULL,
    votes       INTEGER         NOT NULL DEFAULT 0,

)

CREATE TABLE IF NOT EXIST posts (
    id          BIGSERIAL       NOT NULL PRIMARY KEY,
    author      VARCHAR(255)    NOT NULL REFERENCES users (nickname),
    created     DATETIME        NOT NULL ,
    forum       VARCHAR(255)    NOT NULL REFERENCES forums (slug),
    isEdited    BOOLEAN         NOT NULL DEFAULT FALSE,
    messageText TEXT            NOT NULL,
    parent      BIGINT          NOT NULL REFERENCES posts (id),
    thread      BIGINT          NOT NULL REFERENCES threads (id)
)

CREATE TABLE IF NOT EXIST votes ( 
    nickname    VARCHAR(255)    NOT NULL REFERENCES users (nickname),
    voice       TINYINT         NOT NULL
)

CREATE TABLE IF NOT EXIST forumUserRelation (
    user        VARCHAR(255)    NOT NULL REFERENCES users (nickname),
    forum       VARCHAR(255)    NOT NULL REFERENCES forums (slug)       
)
