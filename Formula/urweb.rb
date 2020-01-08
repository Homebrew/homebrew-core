class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20190217/urweb-20190217.tar.gz"
  sha256 "da24e093369a14ae738dfb08d83fcba083ce07360023f6f55734f0e335e880b2"

  bottle do
    sha256 "ef0713473d33906ec3acfba95b92359cabe03c3da905e700e4a6fb722a8f1e36" => :catalina
    sha256 "8cf6738df83cae60b5931a858f5dc6c9fe2666d7548978d78f9587a140c2daa5" => :mojave
    sha256 "316fe61df89c4470e2a0bff1481e8aefa11bc67ca3ff5dad963c57cbfd0c6837" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --prefix=#{prefix}
      SITELISP=$prefix/share/emacs/site-lisp/urweb
      ICU_INCLUDES=-I#{Formula["icu4c"].opt_include}
      ICU_LIBS=-L#{Formula["icu4c"].opt_lib}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"hello.ur").write <<~EOS
      fun target () = return <xml><body>
        Welcome!
      </body></xml>
      fun main () = return <xml><body>
        <a link={target ()}>Go there</a>
      </body></xml>
    EOS
    (testpath/"hello.urs").write <<~EOS
      val main : unit -> transaction page
    EOS
    (testpath/"hello.urp").write "hello"
    system "#{bin}/urweb", "hello"
    system "./hello.exe", "-h"
  end
end
