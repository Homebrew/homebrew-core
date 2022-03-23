class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.0.tar.xz"
  sha256 "d92bd13c5630905eeb6a983dcb702204da9731460c2a6e4e39f867996f371040"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "6843c183a9fcd2198de13cd7ce3de015c5aee0cd7831ef3095951207abbab6ce"
    sha256 arm64_big_sur:  "3136cf5ba11f1eeabf2f85202acf53a3fc84ad5d3972f51c4910bedf84ecbd87"
    sha256 monterey:       "98e39f8070fe543feaea94ca8e71889d778cdf26b0414e141c3c540470da36e1"
    sha256 big_sur:        "d2eff8191696c583fc421dab73e3b9ca6c763dd4a1ef75304ea99ea25462b86b"
    sha256 catalina:       "980ac9fbf9d12a5e5e61c692ae7fe5c530d1c4cbdf3c00273ba61a2b17df5080"
    sha256 x86_64_linux:   "2030b988f35004147510120c2856663875e76a07d534fc124075e304a4d1df9b"
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
