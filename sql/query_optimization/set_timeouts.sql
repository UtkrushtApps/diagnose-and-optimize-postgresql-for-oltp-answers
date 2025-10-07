-- Set statement timeout for OLAP and OLTP sessions
-- Production: Use application/connection pool to set GUC as needed.
-- OLAP sessions:
ALTER DATABASE yourdb SET statement_timeout = '10min';
-- Or at user/role level for analysts.
-- OLTP sessions (API):
ALTER ROLE api_user SET statement_timeout = '3s';
-- Or
-- SET statement_timeout TO '3s';

-- Also consider lock_timeout for further protection:
ALTER ROLE api_user SET lock_timeout = '750ms';
-- OLAP roles can have longer lock_timeout if needed.
