class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.0.tar.xz"
  sha256 "d92bd13c5630905eeb6a983dcb702204da9731460c2a6e4e39f867996f371040"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "5dec35370e5c67ae37ace634b240ec10b276ea1ff0ea9001862df899a4d6d1b4"
    sha256 arm64_big_sur:  "d56cf61921732150bf291f0422e167e59651cdbd1f5766374dd7f2ec5cbd5c1f"
    sha256 monterey:       "9f6526ee41761d9288d64e0ecf2eb565abf9a645a6ca39d59b6d15afc4f30d9a"
    sha256 big_sur:        "021fbe80fdd1403ee526e429c1d709f2ad821e79b7fbb80b145be3857627a664"
    sha256 catalina:       "e865eb8a6d08f501a50ae3a3a4b433fa38d21cfffafe3d475302a0d709f7e3c7"
    sha256 x86_64_linux:   "bd1e8c00d4411eca2042b2349907ba8d8958db86e401dc8c8beb3c824d261586"
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
