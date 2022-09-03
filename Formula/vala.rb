class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.3.tar.xz"
  sha256 "e1066221bf7b89cb1fa7327a3888645cb33b604de3bf45aa81132fd040b699bf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "2bd209117dca513e77dda3fb30aac09fe70e33de746ee534da79763321016d1a"
    sha256 arm64_big_sur:  "f4a0df580a3de5d84f544dba4c652e2c0caf2abbde86aa2c3c7dcb46efad5ca9"
    sha256 monterey:       "7a57596dd9b29ae2d3dca304d7797832174c57c467e81df669261c7e66d54ff8"
    sha256 big_sur:        "d084fc68f777a4788b709e505bcad0257598b76b7cdb3f93fa901a6989cf2ce1"
    sha256 catalina:       "c9f5f66abea2d4d1d49d23e4bad08bc2cf6a8285517e61fe96661ddd1c3cb5bb"
    sha256 x86_64_linux:   "bc182eae4d8a5496e2569f1236cd74bc4c5f32a636b724e485ffcf39ef306814"
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
