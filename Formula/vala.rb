class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.3.tar.xz"
  sha256 "e29c2b1f108dc22c91bb501975a77c938aef079ca7875e1fbf41191e22cc57e3"

  bottle do
    sha256 "8aee03bb3645aff691e834261cf2f8e3b44db1ad1475bc86db78e87dc83bf5a2" => :catalina
    sha256 "93b241ec1d81455e97b19e45d188ccaeaba3e3c13e1074d2431e3ad56c3b3367" => :mojave
    sha256 "2ed380ac26b4e585766b923275c5ffa0db334fa70ef72d165525235d74c11aee" => :high_sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

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
