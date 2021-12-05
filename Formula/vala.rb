class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.4.tar.xz"
  sha256 "6051270a2fc30de023c88562566f2f6043e67beb4da4b799c14cdf12048eb40c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "88852b50b04bededcf0f4773166e7134ac83224634a25d056b511190c90b582e"
    sha256 monterey:      "c98e53a66e8a24063af1b23deef5a2d549253d1de18c974f35aa9b468e373d44"
    sha256 big_sur:       "7e7485aeacd9b15ec457908445c3f0f402186d9e729f73cca5088c21e55cc06e"
    sha256 catalina:      "9e57938bb048398951785d3636ed3a9e914170c89f2751bfd6410523c927cc50"
    sha256 x86_64_linux:  "41cbf517df8232245c7affce8e250537180b1316c9a85288094acbc8124b519c"
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
