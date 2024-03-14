class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.16.tar.xz"
  sha256 "05487b5600f5d2f09e66a753cccd8f39c1bff9f148aea1b7774d505b9c8bca9b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "fb72d33a6fbd6c011256287209fa441228bf51a58e7a0ddfd7ecec10d44d7157"
    sha256 arm64_ventura:  "d2d7c1d12aeb4f3729afa934ac0b4fef98bb4b034d37afb7356f63c666345f80"
    sha256 arm64_monterey: "c65a7f650ddf3122ec0fc6e2ec8a353491f01d33233337a7911e50f02c281f36"
    sha256 sonoma:         "5c6a8b4a4f26fa37f5ff7dbc28d81ef8b9bc3c34c996a7724093d316dce04490"
    sha256 ventura:        "3d254f90df2aa70e579f7362f41165afcf5d3967deb3566b84a6d57f16730a2f"
    sha256 monterey:       "7737c5dd0276f8942578d65330b2f652a16ab198b94c09fa904de2a3c932c1b7"
    sha256 x86_64_linux:   "f23db56d0683a016d7b8a288ab901b97525e374aa162cf5cc5578ea2197c3d04"
  end

  depends_on "gobject-introspection" => :build
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
