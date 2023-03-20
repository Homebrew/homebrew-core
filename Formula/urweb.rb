class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 7

  bottle do
    sha256 arm64_ventura:  "82e320ad81556f0dbacdd1c4b6f0e5889916a007999e321ed14bae4229c0223f"
    sha256 arm64_monterey: "c61ed88655ea20cd8ba60360a6714f7c6e1a0c3545d7db09795ed4518e81e98d"
    sha256 arm64_big_sur:  "694565c03481269805e258f66a627c4a9f44edeb4c5a76dd0c287d98d1032b65"
    sha256 ventura:        "98cf98bfe452be1eb929cf3777fb9f5d8ad55078795f1f3b0ab2495bc29fdc7c"
    sha256 monterey:       "acab43be30ea6fd2cd2c54df953a58b867ad727fb75212b24be1d00642d7ae61"
    sha256 big_sur:        "d94f93d07f4c8c0ec50fd312b068b35f559f1deb381b8e5bf0c50a05dbfc1908"
    sha256 x86_64_linux:   "4a5c86f665bfc69b300959de3c6e7fcd57316489659020c861c56542ce484de1"
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
