class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.9.tar.xz"
  sha256 "c7ff0480779b2d78d6ff78f5fd165b3ba972e4fa9e9da1b411ff4375a78c6a7b"

  bottle do
    sha256 "c392e40f50c8f4cbbe908cf2572ddbf0a43428be59d4c5d39f00039fee655867" => :high_sierra
    sha256 "bdc3a47386df2b2510824e2102e1375c78fb9733073f1cc2f36c52a86826a904" => :sierra
    sha256 "2bcc5175413ec988d16fc9aaa77e817062a69bb2e3905ed034a28db734db2360" => :el_capitan
  end

  depends_on "pkg-config"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
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
