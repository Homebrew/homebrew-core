class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.2.tar.xz"
  sha256 "3a3c460803ba661e513be3d0984b583e05473f602c75fa98e91755503714a97b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "f780e829e33fcabc75877ca11accf3f4bc2e701d9fa7e462f4f68a1919cb64a7"
    sha256 big_sur:       "6e19554cd3e3a0aa59d708b38ec94cd879108f4ac38a63be88b6b148d2687ad5"
    sha256 catalina:      "ce923b04aaaf05d594b1a881fcfa7ab4a9cbcbec191c9754c4e328d490b95625"
    sha256 mojave:        "aa5b565524f3713b0bc09efdd9d70714348cbd1b7e76d47898e2623297790897"
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
