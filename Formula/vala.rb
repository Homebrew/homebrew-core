class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.4.tar.xz"
  sha256 "357fb15517bb5da506b7fdcb4033802a8a5f8e6502e86b8304371b4e2132c8ef"

  bottle do
    sha256 "91ba81683e08ff484017546c9dd65473881748e95fd364007e4332e0885c362f" => :mojave
    sha256 "fe4cbd5dccee40b7e180caa6bcab63b394929e3c2666e077596d33085ba47c31" => :high_sierra
    sha256 "5280279376f172564366d37305b28e13537838e8d08c624d3cd799cada3580d8" => :sierra
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
