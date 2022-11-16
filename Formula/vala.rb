class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.3.tar.xz"
  sha256 "e1066221bf7b89cb1fa7327a3888645cb33b604de3bf45aa81132fd040b699bf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "7cefffab4f86d1dff6b881892fe16eec70f943e6a14ec428c4bdcd626fb69e21"
    sha256 arm64_monterey: "9710ea0dd1f5bbba23f41bf54982705a5c7fc6d4b35ae68fc8f6d65c876519ac"
    sha256 arm64_big_sur:  "e5cf9e8f047f4ddf31b0f25c3076c6cc8b1ee9982de3d242b4796275af60a4e2"
    sha256 ventura:        "a37e353afc48e25f09258bc9cc15b66eaf582fe0779a2243ac499d0b188a51da"
    sha256 monterey:       "f8239f01d9b18c4be6d83b97c42a93c4ab436d3d13bab3f95d609b422ea0c2e9"
    sha256 big_sur:        "bc77fabfbd06743e37f1c9ee78f1c608d68b4bf1c34783b75d2d8f5ed00cbc3a"
    sha256 catalina:       "56ac3f0303166a5d6c556e8a899fbc5f3a743f38b84915dc19457c4284523f46"
    sha256 x86_64_linux:   "13bdb063f26cf187830b4b1b9c70f7a5f73947cde1e3adec62b0d295c16e2735"
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
