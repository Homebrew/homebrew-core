class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 arm64_monterey: "84309cfc8cb6b2e14562ce710309537717b27fbb2ba8e8d03ae77bcc15ab598e"
    sha256 arm64_big_sur:  "216fa86e471dd591cc187e09ea6cf97f52b54f9f415bc0938ca82365870c475f"
    sha256 monterey:       "82624c39378509939cb3a3dac20dde40ff2db659b8c01d4e21616c3841cd9dd6"
    sha256 big_sur:        "d7d9ea068bec51f020dbdf77e642ddb0ba5fc3bc79f694f9e1162c22fffc1074"
    sha256 catalina:       "7cc49cd4e66b35b3b283a93af77e4ff4d2eb2482478888f645eb05889dde69a3"
    sha256 x86_64_linux:   "30b601aa8761349f8097b71ee619b3c517a63d2798a5f1ef233d6085ab8a3c80"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@3"

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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "SITELISP=$prefix/share/emacs/site-lisp/urweb",
                          "ICU_INCLUDES=-I#{Formula["icu4c"].opt_include}",
                          "ICU_LIBS=-L#{Formula["icu4c"].opt_lib}"
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
