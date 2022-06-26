class TelegramCli < Formula
  desc "Command-line interface for Telegram"
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      tag:      "1.3.1",
      revision: "5935c97ed05b90015418b5208b7beeca15a6043c"
  license "GPL-2.0"
  revision 4
  head "https://github.com/vysheng/tg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "2a2821cb318c0270c4a51154c662257262e956e46621dc908f78448981c2284a"
    sha256 arm64_big_sur:  "335e874e6767796259265d4d62d144b599c37f7d5e98a54c36903e0733b50ce3"
    sha256 monterey:       "f70222afc6e527354cd71857668550130d8fb2de2fb08ace0127db745f69d87a"
    sha256 big_sur:        "a2cf1d0764a462e736640449bb3ca11522ec0c38a4dfb2e54ff3ccc3556f7ff9"
    sha256 catalina:       "4c1a9d233c3b46d75badb6e89e007ff9763e55071474ce11d0e109e7ee24aefe"
    sha256 mojave:         "da9d09f1f4a317ed14c97e67fc2def18c4cd728a7023ab80424a8d548437ee74"
    sha256 high_sierra:    "410b56cc04620c7a1f495b500b41fa61339cc68444c1c65939bb4fb0c4cc96ef"
    sha256 x86_64_linux:   "a8e2ef70303824cf404b4d481ac67194c8240611aafcef592bec5311f36d7d08"
  end

  # "This project is deprecated and is no longer being maintained.
  # Last commit was in 2016
  deprecate! date: "2021-06-30", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libconfig"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  # Look for the configuration file under /usr/local/etc rather than /etc on OS X.
  # Pull Request: https://github.com/vysheng/tg/pull/1306
  patch do
    url "https://github.com/vysheng/tg/commit/7fad505c344fdee68ea2af1096dc9357e50a8019.patch?full_index=1"
    sha256 "1cdaa1f3e1f7fd722681ea4e02ff31a538897ed9d704c61f28c819a52ed0f592"
  end

  # Patch for OpenSSL 1.1 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/129507e4ee3dc314156e179902ac375abd00c7fa/telegram-cli/openssl-1.1.diff"
    sha256 "eb6243e1861c0b1595e8bdee705d1acdd2678e854f0919699d4b26c159e30b5e"
  end

  # Patch to make telegram-cli use sysconfdir for Apple Silicon support
  # This patch does not apply cleanly to 1.3.1, but applies cleanly to head.
  # using inline patch for the tag this is checking out.
  # patch do
  #   url "https://github.com/vysheng/tg/commit/63b85c3ca1b335daf783d6e9ae80c076e7406e39.patch?full_index=1"
  #   sha256 "cbc37bd03b7456a43dbedeb5c8dd17294e016d8e8bb36f236f42f74bde4d7a71"
  # end
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
      --disable-liblua
      --sysconfdir=#{etc}
    ]

    system "./configure", *args
    system "make"

    bin.install "bin/telegram-cli" => "telegram"
    (etc/"telegram-cli").install "server.pub"
  end

  test do
    assert_match "messages_allocated", pipe_output("#{bin}/telegram", "stats")
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index e1989ab..78d84d0 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -2,7 +2,7 @@ srcdir=@srcdir@

 CFLAGS=@CFLAGS@
 LDFLAGS=@LDFLAGS@ @OPENSSL_LDFLAGS@
-CPPFLAGS=@CPPFLAGS@ @OPENSSL_INCLUDES@
+CPPFLAGS=@CPPFLAGS@ @OPENSSL_INCLUDES@  -DSYSCONFDIR='"@sysconfdir@"'
 DEFS=@DEFS@
 COMPILE_FLAGS=${CFLAGS} ${CPFLAGS} ${CPPFLAGS} ${DEFS} -Wall -Wextra -Werror -Wno-deprecated-declarations -fno-strict-aliasing -fno-omit-frame-pointer -ggdb -Wno-unused-parameter -fPIC

diff --git a/main.c b/main.c
index 9498b0b..ba97e36 100644
--- a/main.c
+++ b/main.c
@@ -927,8 +927,16 @@ int main (int argc, char **argv) {
   running_for_first_time ();
   parse_config ();

-  #if defined(__FreeBSD__) || (defined(__APPLE__) && defined(__MACH__))
-  tgl_set_rsa_key (TLS, "/usr/local/etc/" PROG_NAME "/server.pub");
+  #if defined(__FreeBSD__)
+  /* at the time of adding --sysconfdir to configure I do not know if FreeBSD has it set to /usr/local/etc */
+  #undef SYSCONFDIR
+  #define SYSCONFDIR "/usr/local/etc"
+  #endif
+
+  #if defined(SYSCONFDIR)
+  /* if --sysconfdir was provided to configure use it, not touching FreeBSD as I'm not sure if
+     the default is correct there */
+  tgl_set_rsa_key (TLS, SYSCONFDIR "/" PROG_NAME "/server.pub");
   #else
   tgl_set_rsa_key (TLS, "/etc/" PROG_NAME "/server.pub");
   #endif
