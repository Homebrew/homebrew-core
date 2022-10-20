class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 1
    sha256 arm64_monterey: "bf59d45c3f80fa791e85e2da484773d0e571839076bb9314c57af39b7722cb71"
    sha256 arm64_big_sur:  "0759a24040fc7112cf1eb8512371e954c1b5b4f84d8a19fb14a938aef021533b"
    sha256 monterey:       "b91f8faa12123ec1c8b75f431e2a7cd0d172a9fb56bcdd384d8e34d35112c042"
    sha256 big_sur:        "ec570b4ddd402fd2a2a2cbd9e9be87d1d07e6f888724eb52c4a8d68f93dd9bf4"
    sha256 catalina:       "2215d28b890d29d68f2d90bf371f606fcf7b07de606b1adcb06ffb73360d3558"
    sha256 x86_64_linux:   "4ab2001394d21e6a658dc5fd5088ae9949aa4080893ae2731bfff3f2501fa764"
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
