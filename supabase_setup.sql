-- ============================================================
-- BusinessNext Compliance Dashboard — Supabase Setup v3.0
-- Run this in your Supabase project: SQL Editor → New Query
-- ============================================================

-- 1. Create the status tracking table (v3.0 — includes notes column)
CREATE TABLE IF NOT EXISTS public.compliance_actions (
  id          INTEGER PRIMARY KEY,
  status      TEXT NOT NULL DEFAULT 'Open',
  notes       TEXT DEFAULT '',
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- If upgrading from v2.0, run this to add the notes column:
-- ALTER TABLE public.compliance_actions ADD COLUMN IF NOT EXISTS notes TEXT DEFAULT '';

-- 2. Seed all 51 action items with initial statuses
INSERT INTO public.compliance_actions (id, status, notes) VALUES
  -- IDs 1–39 (from v2.0 with updated statuses per Aug 2026 analysis)
  (1,  'Open', ''),  -- POSH MH Inspection — OVERDUE per due date logic
  (2,  'Open', ''),  -- Model Standing Orders
  (3,  'Open', ''),  -- Code on Wages Audit
  (4,  'Open', ''),  -- EPF Contribution Aug 15
  (5,  'Open', ''),  -- ESI Contribution Aug 15
  (6,  'Open', ''),  -- MH PT Aug 15
  (7,  'Open', ''),  -- MH PT Employer Enrolment (Overdue)
  (8,  'Open', ''),  -- Aadhaar Authentication
  (9,  'Open', ''),  -- ESI Wage Ceiling
  (10, 'Open', ''),  -- Worker Reskilling Fund
  (11, 'Open', ''),  -- ESIC Health Check-up 40+
  (12, 'Overdue', ''), -- NATS Stipend Revision (CSV confirmed Overdue)
  (13, 'Overdue', ''), -- UP Bakrid Holiday (CSV confirmed Overdue)
  (14, 'Open', ''),  -- MH Draft OSH Rules
  (15, 'Open', ''),  -- MH Draft SS Rules
  (16, 'Open', ''),  -- OSH Central Rules
  (17, 'Open', ''),  -- SS Central Rules
  (18, 'Open', ''),  -- RPD Act Acid Attack Amendment
  (19, 'Open', ''),  -- IR Code Amendment — Legacy Repeal
  (20, 'Open', ''),  -- MoLE Compliance Handbook
  (21, 'Open', ''),  -- EPFO PAN Linking
  (22, 'Open', ''),  -- MH VDA Revision Jan–Jun 2026
  (23, 'Open', ''),  -- UP S&E Amendment Bill
  (24, 'Open', ''),  -- UP Draft Labour Code Rules
  (25, 'Open', ''),  -- Budget 2026-27 IT/EPF
  (26, 'Open', ''),  -- ESIC Health Connect App
  (27, 'Open', ''),  -- ESI Draft Regulations 2026 (Sep 5 deadline)
  (28, 'Open', ''),  -- MH Draft Employees Compensation Rules
  (29, 'Open', ''),  -- Creche Facility 50+
  (30, 'Open', ''),  -- Works Committee & GRC
  (31, 'Open', ''),  -- Principal Employer Contractor Bonus
  (32, 'Open', ''),  -- EPFO UAN via UMANG FAT
  (33, 'Open', ''),  -- EPF Interest Rate 8.25%
  (34, 'Open', ''),  -- CPI-IW May 2026
  (35, 'Open', ''),  -- EPF Scheme 2026
  (36, 'Open', ''),  -- EPS 2026
  (37, 'Open', ''),  -- EDLI Scheme 2026
  (38, 'Open', ''),  -- MH Child Labour Rules 2025
  (39, 'Open', ''),  -- SS Code Section 127 — 12% Interest
  -- IDs 40–51 (NEW in v3.0)
  (40, 'Open', ''),  -- Appointment Letters — Mandatory All Employees
  (41, 'Open', ''),  -- Shram Suvidha Registration Audit
  (42, 'Open', ''),  -- ESI Wages Definition Section 2(88)
  (43, 'Open', ''),  -- Canteen Facility 100+ Workers
  (44, 'Open', ''),  -- Standing Orders Multilingual
  (45, 'Open', ''),  -- Nomination Records Non-Family Invalid
  (46, 'Open', ''),  -- VISHWAS 2026
  (47, 'Open', ''),  -- EPFO PF Trust Amnesty 2026
  (48, 'Open', ''),  -- Employees Enrolment Campaign 2026
  (49, 'Open', ''),  -- MH Gig Workers Bill 2026
  (50, 'Open', ''),  -- E-Shram Registration Gig Workers
  (51, 'Open', '')   -- Contract Labour Single Multi-State Licence
ON CONFLICT (id) DO NOTHING;

-- 3. Enable Row Level Security
ALTER TABLE public.compliance_actions ENABLE ROW LEVEL SECURITY;

-- 4. Allow team to read and update (no login required)
--    Project: oviboktiounvchxqortz.supabase.co
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'Team read' AND tablename = 'compliance_actions'
  ) THEN
    CREATE POLICY "Team read" ON public.compliance_actions
      FOR SELECT USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'Team update' AND tablename = 'compliance_actions'
  ) THEN
    CREATE POLICY "Team update" ON public.compliance_actions
      FOR UPDATE USING (true) WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'Team upsert' AND tablename = 'compliance_actions'
  ) THEN
    CREATE POLICY "Team upsert" ON public.compliance_actions
      FOR INSERT WITH CHECK (true);
  END IF;
END $$;

-- ============================================================
-- v3.0 UPGRADE NOTES
-- If upgrading from v2.0 (30 items) to v3.0 (51 items):
--   1. Run: ALTER TABLE public.compliance_actions ADD COLUMN IF NOT EXISTS notes TEXT DEFAULT '';
--   2. Then run the INSERT block above — ON CONFLICT (id) DO NOTHING
--      ensures existing 30 rows are preserved.
--   3. The 12 new rows (IDs 40–51) will be added automatically.
-- ============================================================
