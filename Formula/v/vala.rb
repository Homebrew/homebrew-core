class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.18.tar.xz"
  sha256 "f2affe7d40ab63db8e7b9ecc3f6bdc9c2fc7e3134c84ff2d795f482fe926a382"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "ff65a2101edaaaf53257e189d4ec20038b9de0680d20e5ac69a5d4b3b8276eda"
    sha256 arm64_sonoma:  "6b8f451a970480a28b7f0a1262ce351d12fee05b78db1a31cf7bcc0abc018850"
    sha256 arm64_ventura: "1df01b6ebb0b6ac03027c8621412b8b1f9c8c8e5722d73a9fd9a7ee4233bb41f"
    sha256 sonoma:        "f79cf8415710b5da9d73c837f0660aa3554d9f21c5cfb3af3e7adc2f7a295f61"
    sha256 ventura:       "051ca637d14e377b0d3ad5f7ab497d2f612f5c9c59d96ef89099ad1627977c39"
    sha256 arm64_linux:   "a54dd08666de4550ba75a90050ad1ebaf67cac7bc0990512881b33858cf55ebf"
    sha256 x86_64_linux:  "284b26bcb2fa09af8f5cb85093f1db9145319950b384797d7c64ba1d6f184ad0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkgconf"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~VALA
      void main () {
        print ("#{test_string}");
      }
    VALA

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

    system bin/"valac", *valac_args
    assert_path_exists testpath/"hello.c"

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
