class TelegramCli < Formula
  desc "Command-line interface for Telegram"
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag      => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  revision 4
  head "https://github.com/vysheng/tg.git"

  bottle do
    sha256 "2c250bcdcee5852b694b513765dd6a75d756482399ba50eb757fbf316d6a9f8c" => :mojave
    sha256 "64fb7ce4cbea47744a7fd0e735acb355b8b0765b1b4d7af72aef71665d676382" => :high_sierra
    sha256 "df7a9db972b81626209015fc673b10e2eabde37c266f12c7cf9a3a0f8041aa85" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libconfig"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "readline"

  # Look for the configuration file under /usr/local/etc rather than /etc on OS X.
  # Pull Request: https://github.com/vysheng/tg/pull/1306
  patch do
    url "https://github.com/vysheng/tg/pull/1306.patch?full_index=1"
    sha256 "1cdaa1f3e1f7fd722681ea4e02ff31a538897ed9d704c61f28c819a52ed0f592"
  end

  # Patch for OpenSSL 1.1 compatibility
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
      --disable-liblua
    ]

    system "./configure", *args
    system "make"

    bin.install "bin/telegram-cli" => "telegram"
    (etc/"telegram-cli").install "server.pub"
  end

  test do
    assert_match "telegram-cli", (shell_output "#{bin}/telegram -h", 1)
  end
end
__END__
diff -pur a/tgl/mtproto-client.c b/tgl/mtproto-client.c
--- a/tgl/mtproto-client.c	2019-09-07 14:58:12.000000000 +0200
+++ b/tgl/mtproto-client.c	2019-09-07 15:04:34.000000000 +0200
@@ -143,7 +143,9 @@ static int decrypt_buffer[ENCRYPT_BUFFER

 static int encrypt_packet_buffer (struct tgl_state *TLS, struct tgl_dc *DC) {
   RSA *key = TLS->rsa_key_loaded[DC->rsa_key_idx];
-  return tgl_pad_rsa_encrypt (TLS, (char *) packet_buffer, (packet_ptr - packet_buffer) * 4, (char *) encrypt_buffer, ENCRYPT_BUFFER_INTS * 4, key->n, key->e);
+  const BIGNUM *n, *e;
+  RSA_get0_key(key, &n, &e, NULL);
+  return tgl_pad_rsa_encrypt (TLS, (char *) packet_buffer, (packet_ptr - packet_buffer) * 4, (char *) encrypt_buffer, ENCRYPT_BUFFER_INTS * 4, n, e);
 }

 static int encrypt_packet_buffer_aes_unauth (const char server_nonce[16], const char hidden_client_nonce[32]) {
diff -pur a/tgl/mtproto-common.c b/tgl/mtproto-common.c
--- a/tgl/mtproto-common.c	2019-09-07 14:58:12.000000000 +0200
+++ b/tgl/mtproto-common.c	2019-09-07 15:10:53.000000000 +0200
@@ -178,10 +178,12 @@ int tgl_serialize_bignum (BIGNUM *b, cha
 long long tgl_do_compute_rsa_key_fingerprint (RSA *key) {
   static char tempbuff[4096];
   static unsigned char sha[20];
-  assert (key->n && key->e);
-  int l1 = tgl_serialize_bignum (key->n, tempbuff, 4096);
+  const BIGNUM *n, *e;
+  RSA_get0_key(key, &n, &e, NULL);
+  assert (n && e);
+  int l1 = tgl_serialize_bignum (n, tempbuff, 4096);
   assert (l1 > 0);
-  int l2 = tgl_serialize_bignum (key->e, tempbuff + l1, 4096 - l1);
+  int l2 = tgl_serialize_bignum (e, tempbuff + l1, 4096 - l1);
   assert (l2 > 0 && l1 + l2 <= 4096);
   SHA1 ((unsigned char *)tempbuff, l1 + l2, sha);
   return *(long long *)(sha + 12);
@@ -258,21 +260,21 @@ int tgl_pad_rsa_encrypt (struct tgl_stat
   assert (size >= chunks * 256);
   assert (RAND_pseudo_bytes ((unsigned char *) from + from_len, pad) >= 0);
   int i;
-  BIGNUM x, y;
-  BN_init (&x);
-  BN_init (&y);
+  BIGNUM *x, *y;
+  x = BN_new();
+  y = BN_new();
   rsa_encrypted_chunks += chunks;
   for (i = 0; i < chunks; i++) {
-    BN_bin2bn ((unsigned char *) from, 255, &x);
-    assert (BN_mod_exp (&y, &x, E, N, TLS->BN_ctx) == 1);
-    unsigned l = 256 - BN_num_bytes (&y);
+    BN_bin2bn ((unsigned char *) from, 255, x);
+    assert (BN_mod_exp (y, x, E, N, TLS->BN_ctx) == 1);
+    unsigned l = 256 - BN_num_bytes (y);
     assert (l <= 256);
     memset (to, 0, l);
-    BN_bn2bin (&y, (unsigned char *) to + l);
+    BN_bn2bin (y, (unsigned char *) to + l);
     to += 256;
   }
-  BN_free (&x);
-  BN_free (&y);
+  BN_free (x);
+  BN_free (y);
   return chunks * 256;
 }

@@ -285,26 +287,26 @@ int tgl_pad_rsa_decrypt (struct tgl_stat
   assert (bits >= 2041 && bits <= 2048);
   assert (size >= chunks * 255);
   int i;
-  BIGNUM x, y;
-  BN_init (&x);
-  BN_init (&y);
+  BIGNUM *x, *y;
+  x = BN_new();
+  y = BN_new();
   for (i = 0; i < chunks; i++) {
     ++rsa_decrypted_chunks;
-    BN_bin2bn ((unsigned char *) from, 256, &x);
-    assert (BN_mod_exp (&y, &x, D, N, TLS->BN_ctx) == 1);
-    int l = BN_num_bytes (&y);
+    BN_bin2bn ((unsigned char *) from, 256, x);
+    assert (BN_mod_exp (y, x, D, N, TLS->BN_ctx) == 1);
+    int l = BN_num_bytes (y);
     if (l > 255) {
-      BN_free (&x);
-      BN_free (&y);
+      BN_free (x);
+      BN_free (y);
       return -1;
     }
     assert (l >= 0 && l <= 255);
     memset (to, 0, 255 - l);
-    BN_bn2bin (&y, (unsigned char *) to + 255 - l);
+    BN_bn2bin (y, (unsigned char *) to + 255 - l);
     to += 255;
   }
-  BN_free (&x);
-  BN_free (&y);
+  BN_free (x);
+  BN_free (y);
   return chunks * 255;
 }
