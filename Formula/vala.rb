class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.4.tar.xz"
  sha256 "ecde520e5160e659ee699f8b1cdc96065edbd44bbd08eb48ef5f2506751fdf31"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "5aeae5a53ae70dbb63c2bb31aa7112960584eae16a098ed13a525607f1d18aaf"
    sha256 big_sur:       "a032e72a210fc8f541fbe6e2ba131c172cc57f5f1773f767ab6b1ebc81d8b8dd"
    sha256 catalina:      "08dfe77ba56c3205f304c3543fdc18705d4a3abd15e0e20ef6c2c7194142185d"
    sha256 mojave:        "07eb45b1047e84e43defbfdc684ac559f40b329ac6fa0ccaf94c57473eda65c6"
    sha256 x86_64_linux:  "7d866ddc8aff4700e8652b2136deaae5a7b4eb2d9c8da70852a73a06761ad278"
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Fix regressions in GStreamer VAPI, which cause issues for dependents like `pdfpc`
  # Upstream pdfpc ref: https://github.com/pdfpc/pdfpc/issues/594
  # Upstream vala ref: https://gitlab.gnome.org/GNOME/vala/-/issues/1210
  # Remove in the next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/vala/-/commit/873c879367d1a4d7265e32dda55d4c01d5dd957b.diff"
    sha256 "144b964cee117b6def5c673e7447003bd4a94b7d681c3d7a8ceaf43f709c0992"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
