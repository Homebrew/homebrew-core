class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 13

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "4596096f381a91507e713b114253fcc5bff15db870b8cc7f1e85b8a51557b25f"
    sha256 arm64_sequoia: "bb906be787129114f6f59ee8007188a3b5a06643a4608c030190bc72c992c554"
    sha256 arm64_sonoma:  "2d5bfd7421944c17f97e71c29a0c2c077ce367ac5ed5e6af83606b29e4655547"
    sha256 sonoma:        "8c4f241c187e23f5b1100d222a75a0edcd1128f505ac3e01ad8d6ba5ba4896c4"
    sha256 arm64_linux:   "feee221fe5c5de761321e93f605f3086b0826d34b324331cc093d208a4e640c0"
    sha256 x86_64_linux:  "48ad3234ce16bdaeef9e731818321c939c00db72f9f4cd76607ace6859231c04"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c@78"
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

  def install
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "SITELISP=$prefix/share/emacs/site-lisp/urweb",
                          "ICU_INCLUDES=-I#{icu4c.opt_include}",
                          "ICU_LIBS=-L#{icu4c.opt_lib}"
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
