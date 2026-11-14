// Liga o site à tua base de dados Supabase.
// Enquanto estes dois campos estiverem vazios, o site abre em modo de demonstração
// (os dados ficam só no teu browser e o chat fica desligado).
//
// Onde encontrar: no Supabase, abre o teu projeto > Project Settings > API Keys (e Data API para o URL).
//  - supabaseUrl: o "https://pujrgnnywdcwbgsgknpj.supabase.co/rest/v1/", do género https://abcdefgh.supabase.co
//  - supabaseKey: a chave "sb_publishable_85QWhKbYyFBQRd08r5f5oA_VTcIoKoJ" (ou "anon public"). É feita para estar à vista.
//
// NUNCA coloques aqui a chave "secret" / "service_role". Essa dá acesso total à base de dados.
window.TEMPO_CONFIG = {
  supabaseUrl: "https://pujrgnnywdcwbgsgknpj.supabase.co/rest/v1/",
  supabaseKey: "sb_publishable_85QWhKbYyFBQRd08r5f5oA_VTcIoKoJ"
};
