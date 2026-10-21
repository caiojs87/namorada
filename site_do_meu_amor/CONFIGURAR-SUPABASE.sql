-- Execute UMA vez no Editor SQL do projeto Supabase correto.
-- Corrige o limite de tipos para permitir os oito botões do site.
ALTER TABLE public.carinhos
  DROP CONSTRAINT IF EXISTS carinhos_tipo_check;

ALTER TABLE public.carinhos
  ADD CONSTRAINT carinhos_tipo_check
  CHECK (tipo IN (
    'beijo', 'abraco', 'saudade', 'teamo',
    'pensando', 'orgulho', 'boa-noite', 'surpresa',
    'te_amo', 'pensando_em_voce', 'carinho', 'mensagem'
  ));

-- Mantém a segurança da tabela ligada.
ALTER TABLE public.carinhos ENABLE ROW LEVEL SECURITY;

-- Garante que a tabela esteja publicada no Realtime sem erro se já estiver adicionada.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'carinhos'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.carinhos;
  END IF;
END $$;
