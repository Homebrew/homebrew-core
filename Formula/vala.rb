class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.4.tar.xz"
  sha256 "357fb15517bb5da506b7fdcb4033802a8a5f8e6502e86b8304371b4e2132c8ef"
  revision 1

  bottle do
    sha256 "c82ef32c54d3a545d0b5893f83e3fff131c0608888c931b09c818540f4ad8ab6" => :mojave
    sha256 "57c4ed76cccc9311077c6b524847406f28c099cdca915c62eac0a9e5dc5783c1" => :high_sierra
    sha256 "e3ea065212b4a3dd4cbfcc05a1bf817c06a7b41cbe8ad982aa8fc61bbfc5e9c9" => :sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

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
