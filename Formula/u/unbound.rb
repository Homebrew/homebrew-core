class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.25.0.tar.gz"
  sha256 "062a6eda723fe2f041bee4079b76981569f1d12e066bbd74800242fc1ebddec7"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "670e2b1931adc953b71b505f04cc69785d24ad9c0c7dafba1d31a05df424c7f1"
    sha256 arm64_sequoia: "48b04ba2e5f8b73e573c63c9efd3d98af3ea826923611808e3d4714ddb7b63b4"
    sha256 arm64_sonoma:  "703644274144dd13e29bf4809df5928b9ae4e5c29d5c6dedff2a19ca0a4a9e96"
    sha256 sonoma:        "f4b337ab6a6f1ff8b3fb457ee316f30e897cf572d377168baa67fe52431fb09c"
    sha256 arm64_linux:   "6e06e02e097f97a3c358be39a3598ab9ecb3fce0f6f2c77cdf06ae484e5c880d"
    sha256 x86_64_linux:  "38797000bffaeadbd02e0889d8b3f449c7d4153dc360ecfcfba6416662db92fa"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@4"

  uses_from_macos "expat"

  # OpenSSL 4 makes ASN1_BIT_STRING opaque.
  patch :DATA

  def install
    expat_prefix = OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr" : Formula["expat"].opt_prefix
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libexpat=#{expat_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@4"].opt_prefix}
    ]

    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')

    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  service do
    run [opt_sbin/"unbound", "-d", "-c", etc/"unbound/unbound.conf"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end

__END__
diff --git a/smallapp/unbound-anchor.c b/smallapp/unbound-anchor.c
index 1e02503..d417564 100644
--- a/smallapp/unbound-anchor.c
+++ b/smallapp/unbound-anchor.c
@@ -1675,11 +1675,15 @@ get_usage_of_ex(X509* cert)
 {
 	unsigned long val = 0;
 	ASN1_BIT_STRING* s;
+	const unsigned char* data;
+	int len;
 	if((s=X509_get_ext_d2i(cert, NID_key_usage, NULL, NULL))) {
-		if(s->length > 0) {
-			val = s->data[0];
-			if(s->length > 1)
-				val |= s->data[1] << 8;
+		data = ASN1_STRING_get0_data(s);
+		len = ASN1_STRING_length(s);
+		if(data && len > 0) {
+			val = data[0];
+			if(len > 1)
+				val |= data[1] << 8;
 		}
 		ASN1_BIT_STRING_free(s);
 	}
