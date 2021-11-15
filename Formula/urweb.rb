class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  revision 4

  bottle do
    sha256 monterey: "212e90a0f4bdcabdb0920889937ca45487c937446ead67a280ecb427fc89523c"
    sha256 big_sur:  "f50d69d970a627bff0607a8be0766c12bdc49394e457776731a5dfd40531f82f"
    sha256 catalina: "67b57cdddb86a0563bd6199314399c8c2d1ad393b81544193492c5d764ee6eb1"
    sha256 mojave:   "51695995aeb4389c1517a66ed91f07db0a967b7955fea9507a99d70fb4daf856"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@1.1"

  # Patch to fix build for icu4c 68.2
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d7db3f02fe5dcd1f73c216efcb0bb79ac03a819f/urweb/icu4c68-2.patch"
    sha256 "8ec1ec5bec95e9feece8ff4e9c0435ada0ba2edbe48439fb88af4d56adcf2b3e"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
