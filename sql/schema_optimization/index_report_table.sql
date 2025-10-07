-- Accelerate analytic queries for 'report' table
-- Assume schema: report(id, user_id, report_type, params, generated_at, ...)

CREATE INDEX IF NOT EXISTS idx_report_type_time ON report (report_type, generated_at DESC);
CREATE INDEX IF NOT EXISTS idx_report_user_time ON report (user_id, generated_at DESC);
-- If frequent JSONB filtering:
-- CREATE INDEX IF NOT EXISTS idx_report_params ON report USING gin (params jsonb_path_ops);
