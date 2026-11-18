-- ============================================================================
-- FINCTRL // Esquema de Base de Datos para Supabase (PostgreSQL)
-- Instrucciones:
-- 1. Entra a tu proyecto en https://supabase.com/dashboard
-- 2. Ve a "SQL Editor" en el menú lateral izquierdo y haz clic en "New query"
-- 3. Pega todo este script y presiona "Run" (o Ctrl + Enter)
-- ============================================================================

-- 1. Tabla principal de respaldo y sincronización en tiempo real por perfil
CREATE TABLE IF NOT EXISTS public.finctrl_backups (
  profile_key TEXT PRIMARY KEY DEFAULT 'personal',
  gross_monthly NUMERIC NOT NULL DEFAULT 40000,
  manual_net_monthly TEXT DEFAULT '',
  frequency TEXT NOT NULL DEFAULT 'semanal',
  discount_rule TEXT NOT NULL DEFAULT 'both',
  months_data JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Tabla desglosada por concepto y mes (para consultas SQL o reportes)
CREATE TABLE IF NOT EXISTS public.finctrl_concepts (
  id TEXT NOT NULL,
  month_key TEXT NOT NULL,
  profile_key TEXT NOT NULL DEFAULT 'personal',
  category TEXT NOT NULL,
  custom_category TEXT DEFAULT '',
  name TEXT NOT NULL,
  flow_type TEXT NOT NULL DEFAULT 'expense',
  s1_amount NUMERIC NOT NULL DEFAULT 0,
  s1_status TEXT NOT NULL DEFAULT 'pending',
  s2_amount NUMERIC NOT NULL DEFAULT 0,
  s2_status TEXT NOT NULL DEFAULT 'pending',
  s3_amount NUMERIC NOT NULL DEFAULT 0,
  s3_status TEXT NOT NULL DEFAULT 'pending',
  s4_amount NUMERIC NOT NULL DEFAULT 0,
  s4_status TEXT NOT NULL DEFAULT 'pending',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (profile_key, month_key, id)
);

-- 3. Habilitar Row Level Security (RLS) y permitir acceso con tu Anon Key personal
ALTER TABLE public.finctrl_backups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.finctrl_concepts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Acceso personal finctrl_backups" ON public.finctrl_backups;
CREATE POLICY "Acceso personal finctrl_backups"
  ON public.finctrl_backups
  FOR ALL
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS "Acceso personal finctrl_concepts" ON public.finctrl_concepts;
CREATE POLICY "Acceso personal finctrl_concepts"
  ON public.finctrl_concepts
  FOR ALL
  USING (true)
  WITH CHECK (true);
