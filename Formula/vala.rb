class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.4.tar.xz"
  sha256 "ecde520e5160e659ee699f8b1cdc96065edbd44bbd08eb48ef5f2506751fdf31"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "980295e63a373da1594e5148ee9e5c24b58e43438ca56d3adf6fdf17706d79bc"
    sha256 big_sur:       "41790eff047d0c56c7ffd9c77d3023e932de790418b0035ee7012acb5445586e"
    sha256 catalina:      "ce7947b5fc4ba26282a5866dcc5ccd74f944826b630070cfbc1ebffc1577a5cd"
    sha256 mojave:        "371a985d1f55593678aa4bfa96209e33bba5f8ffd476af12368d702a5d2e1ee9"
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
