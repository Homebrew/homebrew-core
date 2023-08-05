class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.10.tar.xz"
  sha256 "a83ad3af4228f02f2510f8a3e4f3c4f9c36c8605b1261ce6d5d53be35ba1fc4d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "ac281535fb2087ced79ca74c4effa7683ee253e2942369685692772d8eb09f7b"
    sha256 arm64_monterey: "f2c9fa048e9da15216b6961f81bd4cc624de45da919d92c54744b54a1b4b6db4"
    sha256 arm64_big_sur:  "192c2b60b0511515a24ecf6bd49bfd42ee3ac9f8e7a20b4b9034522bd5b55ca5"
    sha256 ventura:        "32002f044716e088a9bc5200d4097aed33496f2786bd3adc489bcbce7276946a"
    sha256 monterey:       "d6e1c8a07a5bcc21a6e6a1b42ef91022cc5af994e17372867bd2007b00f87d2e"
    sha256 big_sur:        "04f4af203d0b2dabee0636577db24bf8bffa265a652fefe7bc89fa97a3e50dc8"
    sha256 x86_64_linux:   "c14b15d729a8c086cc07b0d2857e63b432144b360e7ac877c5ad6499eeaeeb88"
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
