class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.6.tar.xz"
  sha256 "49d60d96a3fdf6c4287397442bc6d6d95bf40aa7df678ee49128c4b11ba6e469"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "aa1fda9a1046cb4590c6092755c490ecdbba62c1785c3fa6aecd4bdcc1c135df"
    sha256 monterey:      "d5cd1c98d7d73cfd6bd3c14919ae4aa2eb309891a891183b01d4858e2bb654d1"
    sha256 big_sur:       "3d64b70a93981c582579c3fd23521b6bb41160c96233883b480b28c9a8dfbe11"
    sha256 catalina:      "9314d6fc8d377f39ca740059fe879b454b78dbbb93f691f6615ab4576424f0d3"
    sha256 x86_64_linux:  "63dc16b955453ed649c6db7a995627ae583f06c26ee3325996f725f097d09791"
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
