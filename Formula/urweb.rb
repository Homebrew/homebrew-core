class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20180616/urweb-20180616.tar.gz"
  sha256 "211793601c3ba958f45b81c30035cf5e3c236650e23bdf4503dc6074fc143e12"

  bottle do
    sha256 "231256636387c96e61448be2afa84936a0a91f5096ac955695e92f6b29c5d7af" => :mojave
    sha256 "e3af81b278f7b8b530241a69007a91af6cf45e648c15537be5dc3c9078ed3eed" => :high_sierra
    sha256 "3b22d7d19cf6a6abadd99ba668b06460bb3c4aab8fc9fc6043c438bbe2939290" => :sierra
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
