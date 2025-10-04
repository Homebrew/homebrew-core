class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.18.tar.xz"
  sha256 "f2affe7d40ab63db8e7b9ecc3f6bdc9c2fc7e3134c84ff2d795f482fe926a382"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "b107f1bbd7f2ef11df45879dfe7eef7c06043148318e1a924b17e8befe0109b5"
    sha256 arm64_sequoia: "0c9df5e695775789df165924d269b06a50037038d4373bdd47efb84f61cde9ad"
    sha256 arm64_sonoma:  "3d2afba20cfa6404b491373e85b36252a644a6ba1f9e0dd3f62c3f3b519ace40"
    sha256 sonoma:        "7be08cdc3ca80eefd9cf5bddffabe828046acd66afa768f6e86baaa69a5e25fd"
    sha256 arm64_linux:   "d562efbe5304e1d15f1eb40be1a2f8f0fceb6ace109866ec9f1089998b90ef81"
    sha256 x86_64_linux:  "6d4a016086637ae5654795825ee3d8de34d9ff43f3b78f5c4b89aa304cc7ed20"
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
