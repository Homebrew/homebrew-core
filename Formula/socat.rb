class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.3.tar.gz"
  sha256 "8cc0eaee73e646001c64adaab3e496ed20d4d729aaaf939df2a761e99c674372"
  revision 1

  bottle do
    cellar :any
    sha256 "8df52f1aac80cb54571c817acf3dc3a37dc7c6cc61efda3ff5d894b802e41488" => :mojave
    sha256 "146f0a748cf86284207e7a23f178eace6019d861add738fca74e74171a079fb6" => :high_sierra
    sha256 "c17ddaf91194b3b06845c63f9d38f364612a5bbee315ff716eccd3b89a543bc2" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  # patch for type conflict, sent upstream
  patch :p0, :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

__END__
--- xio-termios.h	2019-05-11 09:10:55.000000000 +0900
+++ xio-termios.h	2019-05-11 09:11:13.000000000 +0900
@@ -148,7 +148,7 @@
 extern int xiotermios_value(int fd, int word, tcflag_t mask, tcflag_t value);
 extern int xiotermios_char(int fd, int n, unsigned char c);
 #ifdef HAVE_TERMIOS_ISPEED
-extern int xiotermios_speed(int fd, int n, unsigned int speed);
+extern int xiotermios_speed(int fd, int n, speed_t speed);
 #endif
 extern int xiotermios_spec(int fd, int optcode);
 extern int xiotermios_flush(int fd);
