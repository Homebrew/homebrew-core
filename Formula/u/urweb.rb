class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "8b031e47b232c74fa4994071892ef48350072c23d10fba176c57940b14f3df2e"
    sha256 arm64_sequoia: "d2a2bae377f073fe2d317e51597f35f71c806eb738ea9c33c406104185c21a30"
    sha256 arm64_sonoma:  "8cc9db7c2cba0f618994c6efbf153f156179740a159dab9aff5dfe6fbb8fd5ba"
    sha256 sonoma:        "7c962c412b3828ad46562de8d648c24f18670905e246c6eecf56d43527a5ff09"
    sha256 arm64_linux:   "c872e4e66a9f806ea027dae1921c13fb265805085aaed54c6d709c5f444ac427"
    sha256 x86_64_linux:  "93493a6d29c5fe0043e32c74b35ca935c29b2f9faac7e7cae7ea50c46801bc83"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c@78"
  depends_on "openssl@3"

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
