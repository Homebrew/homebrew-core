class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.6.tar.xz"
  sha256 "49d60d96a3fdf6c4287397442bc6d6d95bf40aa7df678ee49128c4b11ba6e469"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "ecc2603c29b855b1a2a096e2fadfe932992773f580ff68a47ca8707ac32cb7fe"
    sha256 monterey:      "dd53beb4c72134ae0965c292e762d64e793f391655e6f547a805ae2d8fdf4c43"
    sha256 big_sur:       "0a126eaa756b14302ad96dd2f65c74eab2a9fc31bca8107a0b3e3b0c05c1e0dd"
    sha256 catalina:      "552cf9bd5758904e49bb68fd2843bf09b054ad4e40b652104ac20ef85ffbb2f9"
    sha256 x86_64_linux:  "4ae96d3686511de7b69b52376c8a9ea8749a628349f236b1a0998fa657e24911"
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
