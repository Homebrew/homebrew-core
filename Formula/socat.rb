class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.3.tar.gz"
  sha256 "8cc0eaee73e646001c64adaab3e496ed20d4d729aaaf939df2a761e99c674372"
  revision 1

  bottle do
    cellar :any
    sha256 "d59da60bfab8d0c13ae081e6fcfc4c95148b4304b4ca373ec22e1a28272473de" => :catalina
    sha256 "9cd58f9c9f906e36325423daa512cc1c2194e9e86f7011905891403a6e8fb82a" => :mojave
    sha256 "e3c00c79b9f326c9cc46116e11a9281ef42bc0b9c1d3ce271cbbfbcf22933c01" => :high_sierra
    sha256 "55324b293c9c94e3550efd38c06f3bd0ba58a20d46fba44d9b444f6f372e8fd6" => :sierra
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
