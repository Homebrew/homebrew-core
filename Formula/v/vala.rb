class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.11.tar.xz"
  sha256 "0cf3baf19f278fbeaf78bab2ee1dd18ce53e0d65bf9c57d5aa000c1832b1de64"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "9adb44142c3525e0f64b2cca12c568713bcf879b1c5bb775719256d868023c4b"
    sha256 arm64_monterey: "fb9313d3108eadcbffdc7016feddd51541902ff28359b43071ef329304d069ce"
    sha256 arm64_big_sur:  "b20ed4f897c44c0bbaaf1eba92e5825afb0999bc116f6b8f6c96c97a5ec7f2bd"
    sha256 ventura:        "e600eb0623d5a01a2bd61eb4ac0643dbf6c0999e1a2ef248ea8803d574f38f2b"
    sha256 monterey:       "3d1523809650057e4e735c53ccd34344d84c44a0076cb970b31424e833e48f7e"
    sha256 big_sur:        "ce11f69f8ded75febef44c6453d5bacc46f85638e3ed1914aef17b1542b1de38"
    sha256 x86_64_linux:   "1c124cdba2fda4d6f7b8deee8f15f448bb0747f65c21844adf1f8e3b6ae1b978"
  end

  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
