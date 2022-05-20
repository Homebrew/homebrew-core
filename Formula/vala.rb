class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.1.tar.xz"
  sha256 "c518b81dfdda82d1cdf586b3f9b2323162cb96bd3cb5a2c03650cea025d91fb9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "05e5872db764a41a0ffca75b7ca821b360f5c0679ad7d81b7149d95e61752ee8"
    sha256 arm64_big_sur:  "6e4934b74281acc5e52ee9563f61c09174ebe70c977ae1dadf9d65cd4e249763"
    sha256 monterey:       "a409a776c4be95e1821a3141f1eb9dfb32f42ed3529e510fe723adceacf64957"
    sha256 big_sur:        "ce8e50536096acbd6b82dcb7a39e6d93cece591a842c69b3926c9b26c2c22082"
    sha256 catalina:       "d6a029fd04014b02ba31360d2b37b010dd9b6cc3ac1f43a9705994a755a934b5"
    sha256 x86_64_linux:   "859df562798f623ff036c3f82cc4e35a2af07fc04063b835f3601c478494560e"
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", *std_configure_args
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
