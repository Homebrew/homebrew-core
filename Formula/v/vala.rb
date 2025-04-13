class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.18.tar.xz"
  sha256 "f2affe7d40ab63db8e7b9ecc3f6bdc9c2fc7e3134c84ff2d795f482fe926a382"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "716e22a94ebd062b913cf3af1e67cbd1f542f42ba8583cbea1e6a7d8e6f49ae4"
    sha256 arm64_sonoma:  "d713590db8dec7752db9aecf7fd62ae2e4137c4c31a2d9c22a342240d387d61b"
    sha256 arm64_ventura: "d537db8f3606aa9e6547ae1641572422774805a486cdc7453f870229bb4430ac"
    sha256 sonoma:        "da6bca3d96f7e0e54f963f048fed63957643a2e10da24eb64967025342082e38"
    sha256 ventura:       "d2966461c680aeca329ca96118aba8b4ccf302b249f5bbe277ed3ca29ea310af"
    sha256 arm64_linux:   "bc87adbb68e280ff0e1b91243a733ef824ba19a1c2680de8370b99c2fb2a1266"
    sha256 x86_64_linux:  "f0f40e3f67e893ab86517cb9426c23584a756a7a35416b1b22dd105c7313d12d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkgconf"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~VALA
      void main () {
        print ("#{test_string}");
      }
    VALA

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

    system bin/"valac", *valac_args
    assert_path_exists testpath/"hello.c"

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
