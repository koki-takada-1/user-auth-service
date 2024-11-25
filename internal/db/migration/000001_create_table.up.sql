CREATE EXTENSION "uuid-ossp";

CREATE TABLE "user" (
  "id" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password_hash" varchar NOT NULL,
  "role_id" uuid NOT NULL,
  "is_verified" bool NOT NULL DEFAULT false,
  "updated_at" timestamptz NOT NULL DEFAULT (now()),
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "role" (
  "id" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "name" varchar NOT NULL,
  "updated_at" timestamptz NOT NULL DEFAULT (now()),
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "sessions" (
  "id" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "username" varchar NOT NULL,
  "refresh_token" varchar NOT NULL,
  "user_agent" varchar NOT NULL,
  "client_ip" varchar NOT NULL,
  "is_blocked" bool NOT NULL,
  "expires_at" timestamptz NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "verify_email" (
  "id" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "username" uuid NOT NULL,
  "email" varchar NOT NULL,
  "secret_code" varchar NOT NULL,
  "is_used" bool NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL DEFAULT (nows()),
  "expired_at" timestamptz NOT NULL DEFAULT (now() + interval '15 minutes')
);

COMMENT ON TABLE "user" IS 'ユーザ';

COMMENT ON COLUMN "user"."name" IS 'ユーザー名';

COMMENT ON COLUMN "user"."email" IS 'メールアドレス';

COMMENT ON COLUMN "user"."password_hash" IS 'ハッシュ化されたパスワード';

COMMENT ON COLUMN "user"."role_id" IS '役割id';

COMMENT ON COLUMN "user"."is_verified" IS '検証済みかどうか';

COMMENT ON TABLE "role" IS '役割';

COMMENT ON COLUMN "role"."name" IS '役割名';

COMMENT ON TABLE "sessions" IS 'セッション';

COMMENT ON COLUMN "sessions"."refresh_token" IS 'リフレッシュトークン';

COMMENT ON COLUMN "sessions"."user_agent" IS 'ユーザーエージェント';

COMMENT ON COLUMN "sessions"."client_ip" IS 'クライアントIP';

COMMENT ON COLUMN "sessions"."is_blocked" IS 'セッションをブロックするかどうか';

COMMENT ON COLUMN "sessions"."expires_at" IS 'セッション有効期限';

COMMENT ON TABLE "verify_email" IS '認証済みEmail';

ALTER TABLE "user" ADD FOREIGN KEY ("role_id") REFERENCES "role" ("id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("username") REFERENCES "user" ("name");

ALTER TABLE "verify_email" ADD FOREIGN KEY ("username") REFERENCES "user" ("name");
