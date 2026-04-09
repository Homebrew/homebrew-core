class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.19.tar.xz"
  sha256 "5ad7cbbfcc0de61b403d6797c9ef60455bfbebd8e162aec33b5b0b097adfb9d5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "3ce508d2757e042f2dda24e5401860ce4ada78085e168daded1748b2c81c3f82"
    sha256 arm64_sequoia: "86eafa4460263bc247aa7549ddc5e42d009c959efaaba80fd6036600f134eb61"
    sha256 arm64_sonoma:  "6c61e5a5ea70744f86a8a6ca5c30c5ba7f2e6932b72a4c258ac9f2642e776b57"
    sha256 sonoma:        "b06b6e076e6eac981829b79e1f37d136330bacfd78ddc8998cc06d570baf752d"
    sha256 arm64_linux:   "ede577294f0579b9e2bde6f6a9c36c9474db911bd6c959c462dcfb8bb92f5f11"
    sha256 x86_64_linux:  "51c3c07098cd1896d0c612cf7237f4ca2e3bd7156c26852bdcc61d4f08dfc7b9"
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
