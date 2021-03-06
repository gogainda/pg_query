module PgQuery
  # From Postgres source: src/include/storage/lockdefs.h
  LOCK_MODE_NO_LOCK = 0 # NoLock is not a lock mode, but a flag value meaning "don't get a lock"
  LOCK_MODE_ACCESS_SHARE_LOCK = 1 # SELECT
  LOCK_MODE_ROW_SHARE_LOCK = 2 # SELECT FOR UPDATE/FOR SHARE
  LOCK_MODE_ROW_EXCLUSIVE_LOCK = 3 # INSERT, UPDATE, DELETE
  LOCK_MODE_SHARE_UPDATE_EXCLUSIVE_LOCK = 4 # VACUUM (non-FULL),ANALYZE, CREATE INDEX CONCURRENTLY
  LOCK_MODE_SHARE_LOCK = 5 # CREATE INDEX (WITHOUT CONCURRENTLY)
  LOCK_MODE_SHARE_ROW_EXCLUSIVE_LOCK = 6 # like EXCLUSIVE MODE, but allows ROW SHARE
  LOCK_MODE_EXCLUSIVE_LOCK = 7 # blocks ROW SHARE/SELECT...FOR UPDATE
  LOCK_MODE_ACCESS_EXCLUSIVE_LOCK = 8 # ALTER TABLE, DROP TABLE, VACUUM FULL, and unqualified LOCK TABLE

  # From Postgres source: src/include/catalog/pg_trigger.h
  TRIGGER_TYPE_ROW = (1 << 0)
  TRIGGER_TYPE_BEFORE = (1 << 1)
  TRIGGER_TYPE_INSERT = (1 << 2)
  TRIGGER_TYPE_DELETE = (1 << 3)
  TRIGGER_TYPE_UPDATE = (1 << 4)
  TRIGGER_TYPE_TRUNCATE = (1 << 5)
  TRIGGER_TYPE_INSTEAD = (1 << 6)
end
