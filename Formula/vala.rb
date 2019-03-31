class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.2.tar.xz"
  sha256 "67d9bb4656d8fe04bcfc1ed7ff35d191df425923de46c921ae3c3d996eee8040"

  bottle do
    sha256 "c346e83202b80aef44b881aa75ef9638ca11c8869f929ec4dbf240feae898270" => :mojave
    sha256 "ea0882879d9babc4b758f699bdec1134d1c25ffbc0312f4a45983e9d96c19f4d" => :high_sierra
    sha256 "f98c976c29310a1d6f45bde6c7764c12fb3b7c6a90bd5754c4f3fa0d1256785f" => :sierra
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
