class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.0.tar.xz"
  sha256 "a10a3b9d60bdfe3349afd3778cd4518b1eb517b59134a70ab5ac845432220c17"

  bottle do
    sha256 "5e9813b3a4b8099d839e16675bd6b7d145790ea08eb3eb0225395a59102d4dd9" => :mojave
    sha256 "90377134310f96133cf21f59d30c3f9ed285ec4269d98f2ff27c49b233e37a0a" => :high_sierra
    sha256 "59b417266c2fda8ae96fe9c150a91f53657de905ba43c114e7418a859b495a42" => :sierra
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
