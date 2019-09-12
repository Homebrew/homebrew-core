class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  revision 1
  head "https://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    sha256 "97cf25d61d474c2115f6448940f924324d630b60776396398662b1368b4544da" => :mojave
    sha256 "7e95dc18fc03a6c1f19385e1507448f23e2e570c9b3ad60bd3fbc05c65295fb8" => :high_sierra
    sha256 "2118d007922d98ae71169be417106f594636e6ff979611b9e51dd2cf09c002b7" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  # Patch for OpenSSL 1.1 compatibility
  # Taken from https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1
  patch :p0, :DATA

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=darwin",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
__END__
--- librtmp/dh.h.orig	2016-02-29 01:15:13 UTC
+++ librtmp/dh.h
@@ -253,20 +253,23 @@ DHInit(int nKeyBits)
   if (!dh)
     goto failed;

-  MP_new(dh->g);
+  const BIGNUM *p;
+  const BIGNUM *g;
+  DH_get0_pqg(dh,&p,NULL,&g);
+  MP_new(g);

-  if (!dh->g)
+  if (!g)
     goto failed;

-  MP_gethex(dh->p, P1024, res);	/* prime P1024, see dhgroups.h */
+  MP_gethex(p, P1024, res);	/* prime P1024, see dhgroups.h */
   if (!res)
     {
       goto failed;
     }

-  MP_set_w(dh->g, 2);	/* base 2 */
+  MP_set_w(g, 2);	/* base 2 */

-  dh->length = nKeyBits;
+  DH_set_length(dh, nKeyBits);
   return dh;

 failed:
@@ -293,12 +296,15 @@ DHGenerateKey(MDH *dh)
       MP_gethex(q1, Q1024, res);
       assert(res);

-      res = isValidPublicKey(dh->pub_key, dh->p, q1);
+      BIGNUM *pub_key, *priv_key, *p;
+      DH_get0_key(dh, &pub_key, &priv_key);
+      DH_get0_pqg(dh,&p,NULL,NULL);
+      res = isValidPublicKey(pub_key, p, q1);
       if (!res)
	{
-	  MP_free(dh->pub_key);
-	  MP_free(dh->priv_key);
-	  dh->pub_key = dh->priv_key = 0;
+	  MP_free(pub_key);
+	  MP_free(priv_key);
+          DH_set0_key(dh, 0, 0);
	}

       MP_free(q1);
@@ -314,15 +320,17 @@ static int
 DHGetPublicKey(MDH *dh, uint8_t *pubkey, size_t nPubkeyLen)
 {
   int len;
-  if (!dh || !dh->pub_key)
+  BIGNUM *pub_key;
+  DH_get0_key(dh, &pub_key, NULL);
+  if (!dh || !pub_key)
     return 0;

-  len = MP_bytes(dh->pub_key);
+  len = MP_bytes(pub_key);
   if (len <= 0 || len > (int) nPubkeyLen)
     return 0;

   memset(pubkey, 0, nPubkeyLen);
-  MP_setbin(dh->pub_key, pubkey + (nPubkeyLen - len), len);
+  MP_setbin(pub_key, pubkey + (nPubkeyLen - len), len);
   return 1;
 }

@@ -364,7 +372,9 @@ DHComputeSharedSecretKey(MDH *dh, uint8_t *pubkey, siz
   MP_gethex(q1, Q1024, len);
   assert(len);

-  if (isValidPublicKey(pubkeyBn, dh->p, q1))
+  BIGNUM *p;
+  DH_get0_pqg(dh,&p,NULL,NULL);
+  if (isValidPublicKey(pubkeyBn, p, q1))
     res = MDH_compute_key(secret, nPubkeyLen, pubkeyBn, dh);
   else
     res = -1;
--- librtmp/handshake.h.orig	2016-02-29 01:15:13 UTC
+++ librtmp/handshake.h
@@ -69,9 +69,9 @@ typedef struct arcfour_ctx*	RC4_handle;
 #if OPENSSL_VERSION_NUMBER < 0x0090800 || !defined(SHA256_DIGEST_LENGTH)
 #error Your OpenSSL is too old, need 0.9.8 or newer with SHA256
 #endif
-#define HMAC_setup(ctx, key, len)	HMAC_CTX_init(&ctx); HMAC_Init_ex(&ctx, key, len, EVP_sha256(), 0)
-#define HMAC_crunch(ctx, buf, len)	HMAC_Update(&ctx, buf, len)
-#define HMAC_finish(ctx, dig, dlen)	HMAC_Final(&ctx, dig, &dlen); HMAC_CTX_cleanup(&ctx)
+#define HMAC_setup(ctx, key, len)	HMAC_Init_ex(ctx, key, len, EVP_sha256(), 0)
+#define HMAC_crunch(ctx, buf, len)	HMAC_Update(ctx, buf, len)
+#define HMAC_finish(ctx, dig, dlen)	HMAC_Final(ctx, dig, &dlen); HMAC_CTX_free(ctx)

 typedef RC4_KEY *	RC4_handle;
 #define RC4_alloc(h)	*h = malloc(sizeof(RC4_KEY))
@@ -117,7 +117,7 @@ static void InitRC4Encryption
 {
   uint8_t digest[SHA256_DIGEST_LENGTH];
   unsigned int digestLen = 0;
-  HMAC_CTX ctx;
+  HMAC_CTX *ctx = HMAC_CTX_new();

   RC4_alloc(rc4keyIn);
   RC4_alloc(rc4keyOut);
@@ -266,7 +266,7 @@ HMACsha256(const uint8_t *message, size_t messageLen,
	   size_t keylen, uint8_t *digest)
 {
   unsigned int digestLen;
-  HMAC_CTX ctx;
+  HMAC_CTX *ctx = HMAC_CTX_new();

   HMAC_setup(ctx, key, keylen);
   HMAC_crunch(ctx, message, messageLen);
--- librtmp/hashswf.c.orig	2016-02-29 01:15:13 UTC
+++ librtmp/hashswf.c
@@ -57,10 +57,10 @@
 #include <openssl/sha.h>
 #include <openssl/hmac.h>
 #include <openssl/rc4.h>
-#define HMAC_setup(ctx, key, len)	HMAC_CTX_init(&ctx); HMAC_Init_ex(&ctx, (unsigned char *)key, len, EVP_sha256(), 0)
-#define HMAC_crunch(ctx, buf, len)	HMAC_Update(&ctx, (unsigned char *)buf, len)
-#define HMAC_finish(ctx, dig, dlen)	HMAC_Final(&ctx, (unsigned char *)dig, &dlen);
-#define HMAC_close(ctx)	HMAC_CTX_cleanup(&ctx)
+#define HMAC_setup(ctx, key, len)	HMAC_Init_ex(ctx, (unsigned char *)key, len, EVP_sha256(), 0)
+#define HMAC_crunch(ctx, buf, len)	HMAC_Update(ctx, (unsigned char *)buf, len)
+#define HMAC_finish(ctx, dig, dlen)	HMAC_Final(ctx, (unsigned char *)dig, &dlen);
+#define HMAC_close(ctx)	HMAC_CTX_free(ctx)
 #endif

 extern void RTMP_TLS_Init();
@@ -289,7 +289,7 @@ leave:
 struct info
 {
   z_stream *zs;
-  HMAC_CTX ctx;
+  HMAC_CTX *ctx;
   int first;
   int zlib;
   int size;
