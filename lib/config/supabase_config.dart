// Praktikum Pemwob - Pertemuan 7
// Tahap 10: Menyiapkan Supabase Client
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066



/// Project URL Supabase
const String supabaseUrl = 'https://supabase.com/dashboard/project/nzlkfdmpjhmedasljmbq';

/// Client key (anon / publishable) yang diizinkan untuk aplikasi.
/// Di dashboard Supabase nilainya ada pada bagian "anon public"
/// atau "publishable key".
const String supabasePublishableKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56bGtmZG1wamhtZWRhc2xqbWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMzMzM4NDYsImV4cCI6MjEwODkwOTg0Nn0.KGt2OlUhgghm0nlnp_Ul-ub6mhSlcgCBsG6F3ru3JsU';

/// Bernilai false selama URL/key masih placeholder, supaya aplikasi
/// tetap bisa dijalankan sebelum credential diisi.
bool get isSupabaseConfigured =>
    !supabaseUrl.contains('https://supabase.com/dashboard/project/nzlkfdmpjhmedasljmbq') &&
    !supabasePublishableKey.contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56bGtmZG1wamhtZWRhc2xqbWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMzMzM4NDYsImV4cCI6MjEwODkwOTg0Nn0.KGt2OlUhgghm0nlnp_Ul-ub6mhSlcgCBsG6F3ru3JsU');
