class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20180616/urweb-20180616.tar.gz"
  sha256 "211793601c3ba958f45b81c30035cf5e3c236650e23bdf4503dc6074fc143e12"

  bottle do
    sha256 "a7cbf10bfa6dbe42d613628d5a28b7e520bb186a142869cd72714cdf0efd854a" => :mojave
    sha256 "05ac2c317acf517a4a2dd4d44a685493b801d789ea641c279530a39ee8d8a626" => :high_sierra
    sha256 "dd118040a6ceabe95278dd24b5f5a40b6ccd397d5e939431ef84d89fcd7e592c" => :sierra
    sha256 "0f0509d8d889c80afa2dcbcac7b769f88cb093861520782acc42f608fdd5e830" => :el_capitan
    sha256 "f79d529de35aadf39e6568d257be44688f983cfa0074b71e62015305fe787fd9" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-openssl=#{Formula["openssl"].opt_prefix}
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
