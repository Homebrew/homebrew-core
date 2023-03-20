class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.4.tar.xz"
  sha256 "862c41d938543ed3d8d86c8219a61087797193defee8da0c50caf49993c66b6a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "db54cec04e9304495e0afddbe16aee8a2f9e119c05c350d33de9e7d9d7659362"
    sha256 arm64_monterey: "241055c1404cdeeea35468c670b5fcd5cc196451f0603f9d1db6feb50491306c"
    sha256 arm64_big_sur:  "98d9ea416172b21334599564e39cae11c39efdace1652dfbe3abbb4310c74bdd"
    sha256 ventura:        "9e6a4cc2df6a56e809f7c802e1810a1089261423ff694bc9889c253c0a95ce77"
    sha256 monterey:       "62007a069be3fbdbd5499e9cebf278fa7a94cbd1fb142e2a5b65febef5c1bc75"
    sha256 big_sur:        "1a9aa9081abd9a305c8d2be03a8ec6b5f9fb048b48eefc455c77cd9a4b597661"
    sha256 x86_64_linux:   "137361ef3301c5527413f5de7a8972cb1d8f6fd4d813e73a7d3059e288344056"
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
