class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  revision 13

  stable do
    url "http://files.upscaledb.com/dl/upscaledb-2.2.0.tar.gz"
    mirror "https://dl.bintray.com/homebrew/mirror/upscaledb-2.2.0.tar.gz"
    sha256 "7d0d1ace47847a0f95a9138637fcaaf78b897ef682053e405e2c0865ecfd253e"

    # Remove for > 2.2.2
    # Upstream commit from 12 Feb 2018 "Fix compilation with Boost 1.66 (#110)"
    patch do
      url "https://github.com/cruppstahl/upscaledb/commit/01156f9a8.patch?full_index=1"
      sha256 "e65b9f2b624b7cdad00c3c1444721cadd615688556d8f0bb389d15f5f5f4f430"
    end
  end

  bottle do
    cellar :any
    sha256 "fa357c83b845d76c242a7c10bd59c7ec9d9d7a3f539098b5e97dc0378e9072d4" => :mojave
    sha256 "9e509efa7f8d97a661dc24ee58ed01e1135b5c7e4c03938fbcaf3e8397162f1f" => :high_sierra
    sha256 "809ef6834e3b71efb921646efa43a752fb9486680e91125700033f6c6e34651d" => :sierra
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"
  depends_on "gnutls"
  depends_on :java
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.37.tar.gz"
    sha256 "4c12bed4936dc16a20117adfc5bc18889fa73be8b6b083993862628469a1e931"
  end

  # Patch for compatibility with OpenSSL 1.1
  # https://github.com/cruppstahl/upscaledb/issues/124
  patch :DATA

  def install
    # Fix collision with isset() in <sys/params.h>
    # See https://github.com/Homebrew/homebrew-core/pull/4145
    inreplace "./src/5upscaledb/upscaledb.cc",
      "#  include \"2protobuf/protocol.h\"",
      "#  include \"2protobuf/protocol.h\"\n#define isset(f, b)       (((f) & (b)) == (b))"

    system "./bootstrap.sh" if build.head?

    resource("libuv").stage do
      system "make", "libuv.dylib", "SO_LDFLAGS=-Wl,-install_name,#{libexec}/libuv/lib/libuv.dylib"
      (libexec/"libuv/lib").install "libuv.dylib"
      (libexec/"libuv").install "include"
    end

    ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
    ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
    ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "JDK=#{ENV["JAVA_HOME"]}"
    system "make", "install"

    pkgshare.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           pkgshare/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
__END__
diff -pur upscaledb-2.2.0/src/2aes/aes.h upscaledb-2.2.0-fixed/src/2aes/aes.h
--- upscaledb-2.2.0/src/2aes/aes.h	2016-04-03 21:14:50.000000000 +0200
+++ upscaledb-2.2.0-fixed/src/2aes/aes.h	2019-09-07 18:01:05.000000000 +0200
@@ -48,19 +48,19 @@ class AesCipher {
     AesCipher(const uint8_t key[kAesBlockSize], uint64_t salt = 0) {
       uint64_t iv[2] = {salt, 0};

-	    EVP_CIPHER_CTX_init(&m_encrypt_ctx);
-	    EVP_EncryptInit_ex(&m_encrypt_ctx, EVP_aes_128_cbc(), NULL, key,
+	    m_encrypt_ctx = EVP_CIPHER_CTX_new();
+	    EVP_EncryptInit_ex(m_encrypt_ctx, EVP_aes_128_cbc(), NULL, key,
						(uint8_t *)&iv[0]);
-	    EVP_CIPHER_CTX_init(&m_decrypt_ctx);
-	    EVP_DecryptInit_ex(&m_decrypt_ctx, EVP_aes_128_cbc(), NULL, key,
+	    m_decrypt_ctx = EVP_CIPHER_CTX_new();
+	    EVP_DecryptInit_ex(m_decrypt_ctx, EVP_aes_128_cbc(), NULL, key,
						(uint8_t *)&iv[0]);
-	    EVP_CIPHER_CTX_set_padding(&m_encrypt_ctx, 0);
-	    EVP_CIPHER_CTX_set_padding(&m_decrypt_ctx, 0);
+	    EVP_CIPHER_CTX_set_padding(m_encrypt_ctx, 0);
+	    EVP_CIPHER_CTX_set_padding(m_decrypt_ctx, 0);
     }

     ~AesCipher() {
-      EVP_CIPHER_CTX_cleanup(&m_encrypt_ctx);
-  	  EVP_CIPHER_CTX_cleanup(&m_decrypt_ctx);
+      EVP_CIPHER_CTX_free(m_encrypt_ctx);
+  	  EVP_CIPHER_CTX_free(m_decrypt_ctx);
     }

     /*
@@ -75,11 +75,11 @@ class AesCipher {
	    /* update ciphertext, c_len is filled with the length of ciphertext
	     * generated, len is the size of plaintext in bytes */
	    int clen = (int)len;
-	    EVP_EncryptUpdate(&m_encrypt_ctx, ciphertext, &clen, plaintext, (int)len);
+	    EVP_EncryptUpdate(m_encrypt_ctx, ciphertext, &clen, plaintext, (int)len);

	    /* update ciphertext with the final remaining bytes */
	    int outlen;
-	    EVP_EncryptFinal(&m_encrypt_ctx, ciphertext + clen, &outlen);
+	    EVP_EncryptFinal(m_encrypt_ctx, ciphertext + clen, &outlen);
     }

     /*
@@ -92,13 +92,13 @@ class AesCipher {
       assert(len % kAesBlockSize == 0);

	    int plen = (int)len, flen = 0;
-	    EVP_DecryptUpdate(&m_decrypt_ctx, plaintext, &plen, ciphertext, (int)len);
-	    EVP_DecryptFinal(&m_decrypt_ctx, plaintext + plen, &flen);
+	    EVP_DecryptUpdate(m_decrypt_ctx, plaintext, &plen, ciphertext, (int)len);
+	    EVP_DecryptFinal(m_decrypt_ctx, plaintext + plen, &flen);
     }

   private:
-    EVP_CIPHER_CTX m_encrypt_ctx;
-    EVP_CIPHER_CTX m_decrypt_ctx;
+    EVP_CIPHER_CTX *m_encrypt_ctx;
+    EVP_CIPHER_CTX *m_decrypt_ctx;
 };

 } // namespace upscaledb
