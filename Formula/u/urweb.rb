class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 13

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "85fe75f9c21273edbc5bfb1f496d229826dd87b2d97e9d63d7897ce2980ed1fc"
    sha256 arm64_tahoe:       "79dfe35abdcaf3f9be1986272952f8c09e02ebf0c0a1caa632592666259aa71c"
    sha256 arm64_sequoia:     "84d7b02b05ddcae5bfeb4c0c48cf973aebbf58e43ef62ba8fbec8a199ae3969b"
    sha256 arm64_linux:       "57976ec45c07ca3d1098d2012452c106d430fff21eba36ac924304000a918a81"
    sha256 x86_64_linux:      "38d159c35a80ea70441e2c6109d709a690ee69bd926ae85be545b6db1c24b3fc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c@79"
  depends_on "openssl@4"

  # Patch to fix build for icu4c 68.2
  patch do
    file "Patches/urweb/icu4c68-2.patch"
    type :unofficial
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    type :unofficial
  end

  deny_network_access!

  def icu4c = deps.map(&:name).find { |d| d.match?(/^icu4c(@\d+)?$/) }

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{formula_opt_prefix(openssl)}",
                          "SITELISP=$prefix/share/emacs/site-lisp/urweb",
                          "ICU_INCLUDES=-I#{formula_opt_include(icu4c)}",
                          "ICU_LIBS=-L#{formula_opt_lib(icu4c)}"
    system "make", "install"
  end

  test do
    (testpath/"hello.ur").write <<~URS
      fun target () = return <xml><body>
        Welcome!
      </body></xml>
      fun main () = return <xml><body>
        <a link={target ()}>Go there</a>
      </body></xml>
    URS
    (testpath/"hello.urs").write <<~URS
      val main : unit -> transaction page
    URS
    (testpath/"hello.urp").write "hello"
    system bin/"urweb", "hello"
    system "./hello.exe", "-h"
  end
end
