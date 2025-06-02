class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 12

  bottle do
    sha256 arm64_sequoia: "6b9b4b19d55dd9fa56d0e848f3730131b1d9942e7752af3c4d4cbe9e7865cac5"
    sha256 arm64_sonoma:  "5ae2a880693f266d5a4c97a701f6c275be9af42c6a5001285df1fd5943cf9020"
    sha256 arm64_ventura: "22c6a1384b9b1eceff5db2458d95a6fd4204e7db2073bae3b4b790cf3f3e0fa3"
    sha256 sonoma:        "99566a5188759af116d5a8f53f8250d0b41d81d790712536a17647c98ff7e063"
    sha256 ventura:       "7c0dcc4ba08622d7a5c46e5d71c946c1327adda0c3024a6fa6e2927c7544e5d6"
    sha256 arm64_linux:   "d7f9948cfa0a05c8acd5ed831f1aee5d9b1eff4ec164f315097e621a7d6b1a9b"
    sha256 x86_64_linux:  "85193d19fd4b3065379dce5a2123a7838157f229e84fa71a14fd6e6cc298e62c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c@77"
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
