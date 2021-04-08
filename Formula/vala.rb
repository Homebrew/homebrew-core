class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.1.tar.xz"
  sha256 "17a083ce2405f967efa7d92bce82c49e5f65af334513e3d087a6b4435ed6b9fa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "7823d7fa1c4ac8ba4440c98c957195d4917286df454ec29e1a427be205c1b356"
    sha256 big_sur:       "b60aed09e71856f4c6bb223fe849addf665a9b7988f64bc1ca10e5a6eed39526"
    sha256 catalina:      "a05c6b96de4d59fd6949674e70b28b622a82df803765075983ee10a53bc58919"
    sha256 mojave:        "56248e465d184e85f7f459795d6c034731aa8c4f4dcd3890b72eec28dd79dcf3"
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
