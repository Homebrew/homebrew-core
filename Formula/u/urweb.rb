class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 13

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "450d8d2590ce9389ceebfb6d225e422e663d263a9126fb86f3e1e09204d2639a"
    sha256 arm64_sequoia: "dd6011eaea5988326157c9c961221dfcd0c3a09a715dccd0fe77c0d4f6ee31b5"
    sha256 arm64_sonoma:  "7a371b66878920b5f11487b0ac0c339e4977b627fe30835e06f25171e9261b06"
    sha256 sonoma:        "f9939231dae5d03c24ab515fbefa3f72d9537a96a7dfc5935907e71c614bf304"
    sha256 arm64_linux:   "5f7c081844d6a387936a2e5d8e488a96ef9ac74522bbcfd2390caee39f0d5da8"
    sha256 x86_64_linux:  "be436a74f4dfd296f298a6ca52331b68c441076a13ae2e6b948d48560b97f8ab"
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
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/urweb/icu4c68-2.patch"
    sha256 "8ec1ec5bec95e9feece8ff4e9c0435ada0ba2edbe48439fb88af4d56adcf2b3e"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@4"].opt_prefix}",
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
