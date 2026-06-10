-- ============================================================
-- Page View Counter — Supabase Backend Setup
-- ============================================================
-- 1. Go to https://supabase.com → Create a free account
-- 2. Create a new project (e.g. "ryan-homepage")
-- 3. Go to SQL Editor → paste this entire file → Run
-- 4. Go to Project Settings → API → copy:
--    - Project URL   (e.g. https://xxxxx.supabase.co)
--    - anon/public key
-- 5. Paste them into index.html where it says
--    SUPABASE_URL and SUPABASE_ANON_KEY
-- ============================================================

-- ---------- Table ----------
CREATE TABLE IF NOT EXISTS page_views (
  id          BIGSERIAL PRIMARY KEY,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ip          TEXT,
  user_agent  TEXT,
  page        TEXT DEFAULT '/',
  referrer    TEXT,
  lang        TEXT
);

-- Speed up count(*) queries
CREATE INDEX IF NOT EXISTS idx_page_views_created_at
  ON page_views (created_at DESC);

-- ---------- RLS ----------
ALTER TABLE page_views ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert a page view (the counter)
CREATE POLICY "allow_anon_insert"
  ON page_views FOR INSERT
  TO anon
  WITH CHECK (true);

-- Only you (authenticated) can read the logs
CREATE POLICY "allow_auth_select"
  ON page_views FOR SELECT
  TO authenticated
  USING (true);

-- ---------- RPC: log a page view ----------
-- Called from the browser. Real IP is captured server-side
-- from PostgREST request headers — the browser cannot lie about it.
CREATE OR REPLACE FUNCTION log_page_view()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  headers   JSON;
  client_ip TEXT;
  ua        TEXT;
  ref       TEXT;
  total     BIGINT;
BEGIN
  -- request.headers is a JSON string injected by PostgREST
  BEGIN
    headers := current_setting('request.headers', true)::JSON;
  EXCEPTION WHEN OTHERS THEN
    headers := '{}'::JSON;
  END;

  client_ip :=
    COALESCE(
      headers->>'cf-connecting-ip',          -- Cloudflare
      headers->>'x-forwarded-for',           -- standard proxy chain
      headers->>'x-real-ip',                 -- nginx / some proxies
      '0.0.0.0'
    );

  -- Only keep the first IP if x-forwarded-for is a list
  IF client_ip LIKE '%,%' THEN
    client_ip := SPLIT_PART(client_ip, ',', 1);
  END IF;
  client_ip := TRIM(client_ip);

  ua  := headers->>'user-agent';
  ref := headers->>'referer';

  INSERT INTO page_views (ip, user_agent, page, referrer)
  VALUES (client_ip, ua, '/', ref);

  SELECT COUNT(*) INTO total FROM page_views;
  RETURN total;
END;
$$;

-- Allow anonymous callers to invoke the function
GRANT EXECUTE ON FUNCTION log_page_view() TO anon;
GRANT EXECUTE ON FUNCTION log_page_view() TO authenticated;
