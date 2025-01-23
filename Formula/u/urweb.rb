class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 arm64_sequoia: "e1fc49213a5c984c84898202dd078b55bf3cf6baf72a9f7ede2e28b6ffd2fb81"
    sha256 arm64_sonoma:  "ee1d643f45eb35714ec50820311651b322651f892526a4bc7a0f362e3eecb720"
    sha256 arm64_ventura: "2054bc84d32c0a2dce1b55c13e765dfef2543f47bb8558c632da848bc4669fb5"
    sha256 sonoma:        "4d5a47544891ae36a6726b43fabfa525db32450f6e40fa2bbb258ca7c3d1cd39"
    sha256 ventura:       "80869fade6a1b20b7003666b42a1951330b1ea7d5ee073c150e96f0bc5780c86"
    sha256 x86_64_linux:  "7556e09718c5a0e4ad6fd6b3e30ba6ad6db1632b572659d7f6bcfa5184bfe117"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c@76"
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
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "SITELISP=$prefix/share/emacs/site-lisp/urweb",
                          "ICU_INCLUDES=-I#{icu4c.opt_include}",
                          "ICU_LIBS=-L#{icu4c.opt_lib}"
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
    system bin/"urweb", "hello"
    system "./hello.exe", "-h"
  end
end
