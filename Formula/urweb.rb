class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20180616/urweb-20180616.tar.gz"
  sha256 "211793601c3ba958f45b81c30035cf5e3c236650e23bdf4503dc6074fc143e12"

  bottle do
    rebuild 1
    sha256 "229ca69ebdea39e502031c08c9823bda5dc1dd37cd7dcaef00efea29439ac6a7" => :mojave
    sha256 "7667e5b9837ff7ef824540ac5301e5bdc555a0edd4bc431c9b23d82e1a6c2d17" => :high_sierra
    sha256 "c06a916a0b775eaf2a183ddace6ca55ca8098338f672925b43a721871af588d4" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --prefix=#{prefix}
      SITELISP=$prefix/share/emacs/site-lisp/urweb
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
