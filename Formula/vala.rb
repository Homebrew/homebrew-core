class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.7.tar.xz"
  sha256 "3d39c7596d5fa9ae8bfeae476669f811f7057b7f7b9308478a27b68443d8b003"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "ddf5f7b676c49d4cd1f964724d246b1ee9fc84d61f3d4ed2be9ba9854a12b4af"
    sha256 arm64_monterey: "e516639d649deaac5bad0c8d722de66fe7dbd863e721068da9b2997e04ec74a1"
    sha256 arm64_big_sur:  "7478b59974b9fd82f3d3dd008a3862d42947108cd1b07d2f9bc4572c274a0a8d"
    sha256 ventura:        "acb3c28824b6c51520425cb3b66444ec802d9e7092872e9925368156a2595208"
    sha256 monterey:       "ea7d690baeae7165ea48450c2dc8fc7500dbfd8bc213a17553990b1e88d4dfa2"
    sha256 big_sur:        "2d980d2a6da24489ddebb73b71a22a04064053ad6153af9373a46887b4bfcf18"
    sha256 x86_64_linux:   "895baa08135c3cb58aa930d22cc1ad448964b04c8f852afea61131253b826882"
  end

  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
