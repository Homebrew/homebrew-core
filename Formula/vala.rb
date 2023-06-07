class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.8.tar.xz"
  sha256 "93f81dcfc6a93b77baa271d65e6be981ee3238ad451ef380af118e295d904bde"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "50dcac8fc30867badf1c630528b6be3346589f99b35a44ef545b4be111b668f5"
    sha256 arm64_monterey: "61e562639c4255bfab25a9005faae954e670c5e91a647e1aaef43d3834779bfa"
    sha256 arm64_big_sur:  "2405dccc351b8ecb16341888426f334b61d7119fccd96f57af77ee458c99c599"
    sha256 ventura:        "eb93bc6d1e653c803fcc99631f8e6d3ebe64dadb079bbb62e0de76fccf5d3950"
    sha256 monterey:       "d7765dd6d3327cf9a8c20b9d1c7f66cb89e2c457ef2ff58672fcdc33a9be4258"
    sha256 big_sur:        "75bc78074eaba84f2dc199b1ff1e79120d46d8ae270c36949bca758e6300d9c7"
    sha256 x86_64_linux:   "b0a1dccd23bee0d2585e815f9b08f5448b6b62dcfc3cf0da7092fd096d6e0149"
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
