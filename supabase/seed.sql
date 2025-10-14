-- Seed data for ChargeADS system
-- This file contains initial data for development and testing

-- =============================================
-- INSERT INITIAL ADMIN USER
-- =============================================

-- Note: This will be handled by the auth system when a user signs up
-- But we can create a test admin user for development

-- =============================================
-- INSERT SAMPLE PLAYERS
-- =============================================

INSERT INTO public.players (id, name, description, location, ip_address, status, is_active, last_seen_at) VALUES
(
    '550e8400-e29b-41d4-a716-446655440001',
    'Bar do Fabricio',
    'Player principal do Bar do Fabricio',
    'Salvador - BA',
    '192.168.1.100'::inet,
    'offline',
    true,
    NOW() - INTERVAL '2 hours'
),
(
    '550e8400-e29b-41d4-a716-446655440002',
    'Universo Masculino',
    'Player da loja Universo Masculino',
    'Salvador - BA',
    '192.168.1.101'::inet,
    'offline',
    true,
    NOW() - INTERVAL '1 hour'
),
(
    '550e8400-e29b-41d4-a716-446655440003',
    'Beach Tênis',
    'Player do clube Beach Tênis',
    'Salvador - BA',
    '192.168.1.102'::inet,
    'online',
    true,
    NOW() - INTERVAL '5 minutes'
),
(
    '550e8400-e29b-41d4-a716-446655440004',
    'Pizzaria Lugano',
    'Player da Pizzaria Lugano',
    'Salvador - BA',
    '192.168.1.103'::inet,
    'offline',
    true,
    NOW() - INTERVAL '30 minutes'
),
(
    '550e8400-e29b-41d4-a716-446655440005',
    'Player 05',
    'Player de teste para desenvolvimento',
    'Salvador - BA',
    '192.168.1.104'::inet,
    'offline',
    true,
    NOW() - INTERVAL '45 minutes'
);

-- =============================================
-- INSERT PLAYER STATISTICS
-- =============================================

INSERT INTO public.player_statistics (player_id, uptime_percentage, total_uptime, total_downtime, last_status_change) VALUES
('550e8400-e29b-41d4-a716-446655440001', 85.5, '7 days 12 hours', '1 day 3 hours', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440002', 92.3, '8 days 5 hours', '15 hours 30 minutes', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440003', 96.8, '9 days 2 hours', '8 hours 45 minutes', NOW() - INTERVAL '5 minutes'),
('550e8400-e29b-41d4-a716-446655440004', 78.9, '6 days 8 hours', '1 day 16 hours', NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 88.2, '7 days 15 hours', '1 day 2 hours', NOW() - INTERVAL '45 minutes');

-- =============================================
-- INSERT SAMPLE MEDIA FILES
-- =============================================

INSERT INTO public.media_files (id, filename, original_filename, file_path, file_size, mime_type, duration, resolution, is_active) VALUES
(
    '650e8400-e29b-41d4-a716-446655440001',
    'promo_verao_2024.mp4',
    'Promoção Verão 2024.mp4',
    '/media/videos/promo_verao_2024.mp4',
    52428800,
    'video/mp4',
    30,
    '1920x1080',
    true
),
(
    '650e8400-e29b-41d4-a716-446655440002',
    'logo_empresa.png',
    'Logo da Empresa.png',
    '/media/images/logo_empresa.png',
    204800,
    'image/png',
    NULL,
    '800x600',
    true
),
(
    '650e8400-e29b-41d4-a716-446655440003',
    'menu_pizzaria.jpg',
    'Menu da Pizzaria.jpg',
    '/media/images/menu_pizzaria.jpg',
    153600,
    'image/jpeg',
    NULL,
    '1024x768',
    true
),
(
    '650e8400-e29b-41d4-a716-446655440004',
    'promo_natal_2024.mp4',
    'Promoção Natal 2024.mp4',
    '/media/videos/promo_natal_2024.mp4',
    41943040,
    'video/mp4',
    45,
    '1920x1080',
    true
),
(
    '650e8400-e29b-41d4-a716-446655440005',
    'background_music.mp3',
    'Música de Fundo.mp3',
    '/media/audio/background_music.mp3',
    8388608,
    'audio/mp3',
    180,
    NULL,
    true
);

-- =============================================
-- INSERT SAMPLE PLAYLISTS
-- =============================================

INSERT INTO public.playlists (id, name, description, is_active) VALUES
(
    '750e8400-e29b-41d4-a716-446655440001',
    'Playlist Principal',
    'Playlist principal com conteúdo geral',
    true
),
(
    '750e8400-e29b-41d4-a716-446655440002',
    'Playlist de Promoções',
    'Playlist com promoções e ofertas especiais',
    true
),
(
    '750e8400-e29b-41d4-a716-446655440003',
    'Playlist de Menu',
    'Playlist com cardápios e menus',
    true
);

-- =============================================
-- INSERT PLAYLIST ITEMS
-- =============================================

INSERT INTO public.playlist_items (playlist_id, media_file_id, order_index, duration) VALUES
-- Playlist Principal
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440002', 1, 10), -- Logo (10 segundos)
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', 2, 30), -- Promo Verão (30 segundos)
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440002', 3, 10), -- Logo (10 segundos)

-- Playlist de Promoções
('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', 1, 30), -- Promo Verão
('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440004', 2, 45), -- Promo Natal

-- Playlist de Menu
('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', 1, 15), -- Menu Pizzaria (15 segundos)
('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440002', 2, 10); -- Logo (10 segundos)

-- =============================================
-- INSERT SAMPLE SCHEDULES
-- =============================================

INSERT INTO public.schedules (id, name, description, start_date, end_date, start_time, end_time, is_recurring, recurrence_pattern, is_active) VALUES
(
    '850e8400-e29b-41d4-a716-446655440001',
    'Horário Comercial',
    'Horário de funcionamento normal',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    '08:00:00',
    '18:00:00',
    true,
    'daily',
    true
),
(
    '850e8400-e29b-41d4-a716-446655440002',
    'Horário de Pico',
    'Horário de maior movimento',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    '12:00:00',
    '14:00:00',
    true,
    'daily',
    true
),
(
    '850e8400-e29b-41d4-a716-446655440003',
    'Horário Noturno',
    'Horário noturno para estabelecimentos 24h',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    '22:00:00',
    '06:00:00',
    true,
    'daily',
    true
);

-- =============================================
-- INSERT SCHEDULE ASSIGNMENTS
-- =============================================

INSERT INTO public.schedule_assignments (schedule_id, player_id, playlist_id, priority) VALUES
-- Bar do Fabricio
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', 1),
('850e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440002', 2),

-- Universo Masculino
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440001', 1),

-- Beach Tênis
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440001', 1),
('850e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440002', 2),

-- Pizzaria Lugano
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440003', 1),

-- Player 05
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440001', 1);

-- =============================================
-- INSERT SAMPLE PLAYER LOGS
-- =============================================

-- Generate some sample logs for the last 24 hours
INSERT INTO public.player_logs (player_id, status, message, ip_address, response_time, created_at) VALUES
-- Beach Tênis (online player) - recent logs
('550e8400-e29b-41d4-a716-446655440003', 'online', 'Player responding normally', '192.168.1.102'::inet, 45, NOW() - INTERVAL '5 minutes'),
('550e8400-e29b-41d4-a716-446655440003', 'online', 'Player responding normally', '192.168.1.102'::inet, 42, NOW() - INTERVAL '10 minutes'),
('550e8400-e29b-41d4-a716-446655440003', 'online', 'Player responding normally', '192.168.1.102'::inet, 38, NOW() - INTERVAL '15 minutes'),

-- Bar do Fabricio - offline logs
('550e8400-e29b-41d4-a716-446655440001', 'offline', 'Connection timeout', '192.168.1.100'::inet, NULL, NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'online', 'Player came back online', '192.168.1.100'::inet, 52, NOW() - INTERVAL '2 hours 5 minutes'),
('550e8400-e29b-41d4-a716-446655440001', 'offline', 'Connection lost', '192.168.1.100'::inet, NULL, NOW() - INTERVAL '2 hours 10 minutes'),

-- Universo Masculino - offline logs
('550e8400-e29b-41d4-a716-446655440002', 'offline', 'No response from player', '192.168.1.101'::inet, NULL, NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440002', 'online', 'Player responding', '192.168.1.101'::inet, 48, NOW() - INTERVAL '1 hour 5 minutes'),
('550e8400-e29b-41d4-a716-446655440002', 'offline', 'Connection timeout', '192.168.1.101'::inet, NULL, NOW() - INTERVAL '1 hour 10 minutes'),

-- Pizzaria Lugano - offline logs
('550e8400-e29b-41d4-a716-446655440004', 'offline', 'Player not responding', '192.168.1.103'::inet, NULL, NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440004', 'unstable', 'Intermittent connection', '192.168.1.103'::inet, 120, NOW() - INTERVAL '30 minutes 5 seconds'),
('550e8400-e29b-41d4-a716-446655440004', 'offline', 'Connection lost', '192.168.1.103'::inet, NULL, NOW() - INTERVAL '30 minutes 10 seconds'),

-- Player 05 - offline logs
('550e8400-e29b-41d4-a716-446655440005', 'offline', 'No response', '192.168.1.104'::inet, NULL, NOW() - INTERVAL '45 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 'online', 'Player online', '192.168.1.104'::inet, 55, NOW() - INTERVAL '45 minutes 5 seconds'),
('550e8400-e29b-41d4-a716-446655440005', 'offline', 'Connection timeout', '192.168.1.104'::inet, NULL, NOW() - INTERVAL '45 minutes 10 seconds');

-- =============================================
-- ADDITIONAL SYSTEM SETTINGS
-- =============================================

INSERT INTO public.system_settings (key, value, description, is_public) VALUES
('maintenance_mode', 'false', 'Sistema em modo de manutenção', false),
('backup_enabled', 'true', 'Backup automático habilitado', false),
('backup_frequency', 'daily', 'Frequência do backup', false),
('notification_email', 'admin@chargeads.com', 'Email para notificações do sistema', false),
('api_rate_limit', '1000', 'Limite de requisições por hora', false),
('session_timeout', '3600', 'Timeout da sessão em segundos', false),
('password_min_length', '8', 'Tamanho mínimo da senha', false),
('require_email_verification', 'true', 'Exige verificação de email', false);

-- =============================================
-- UPDATE STATISTICS
-- =============================================

-- Update player statistics with more realistic data
UPDATE public.player_statistics SET 
    uptime_percentage = CASE 
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440001' THEN 85.5
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440002' THEN 92.3
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440003' THEN 96.8
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440004' THEN 78.9
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440005' THEN 88.2
    END,
    last_status_change = CASE 
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440001' THEN NOW() - INTERVAL '2 hours'
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440002' THEN NOW() - INTERVAL '1 hour'
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440003' THEN NOW() - INTERVAL '5 minutes'
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440004' THEN NOW() - INTERVAL '30 minutes'
        WHEN player_id = '550e8400-e29b-41d4-a716-446655440005' THEN NOW() - INTERVAL '45 minutes'
    END;
