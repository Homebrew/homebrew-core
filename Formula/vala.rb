class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.1.tar.xz"
  sha256 "14e579ab85739097849570b642cf09a91ed27765313a5ca6f94d474b199c9f81"

  bottle do
    sha256 "128904497b7dd88d1f61a30d763c209aa6c44c8018ea5396c6bd74bf6b33d11f" => :catalina
    sha256 "96d6db1a61ba34fecbc542853b479cabaa9d99558618c6e438ce86f44afbd4f1" => :mojave
    sha256 "e606278f4af0e93d0c64005232ffa29f5880caa70416d6e645fc49351cc29c03" => :high_sierra
    sha256 "c8001505b0d4ddf16f8ca24f90556dde4a69eaeec2ec296254bb57db82502f2d" => :sierra
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
