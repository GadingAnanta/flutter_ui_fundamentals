// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 10: Menyiapkan Supabase Client
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// Konfigurasi dipisahkan dari file UI.
// KEAMANAN: gunakan hanya Project URL + anon (publishable) key.
// JANGAN pernah menaruh service_role key di aplikasi Flutter.

/// Project URL Supabase (Project Settings -> API -> Project URL).
/// Bentuknya SELALU `https://<project-ref>.supabase.co`
/// BUKAN https://supabase.com/dashboard/... (itu URL dashboard, bukan API).
const String supabaseUrl = 'https://nzlkfdmpjhmedasljmbq.supabase.co';

/// Client key (anon / publishable) yang diizinkan untuk aplikasi.
/// Di dashboard Supabase nilainya ada pada bagian "anon public"
/// atau "publishable key".
const String supabasePublishableKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56bGtmZG1wamhtZWRhc2xqbWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMzMzM4NDYsImV4cCI6MjEwODkwOTg0Nn0.KGt2OlUhgghm0nlnp_Ul-ub6mhSlcgCBsG6F3ru3JsU';

/// Bernilai true jika konfigurasi sudah diisi dan berbentuk benar.
/// Catatan: yang dicek adalah penanda placeholder 'GANTI', BUKAN nilai
/// konfigurasinya sendiri (kalau dicek dengan '!' justru selalu false).
bool get isSupabaseConfigured =>
    !supabaseUrl.contains('GANTI') &&
    supabaseUrl.startsWith('https://') &&
    supabaseUrl.contains('.supabase.co') &&
    !supabaseUrl.contains('supabase.com/dashboard') &&
    !supabasePublishableKey.contains('GANTI');
