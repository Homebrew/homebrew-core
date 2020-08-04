class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.8.tar.xz"
  sha256 "c83a9b7292627bc259dae7cd414c813a48f285b4b2f4b574fa28e6af9a582ab4"
  license "LGPL-2.1"

  bottle do
    sha256 "d40e1a38a66e1a0ba1df8175e8dcf5bf3649d1fff2287282f0412b77f97e8418" => :catalina
    sha256 "eef2b0169f2e0cfd8c4e00c8abe0244532cb28e87ddf7952ced6f9234ad212a7" => :mojave
    sha256 "7aa723ed8b9f34c565a9c436a11a7e72d7e7369c89b029b55934d8a7952aa38b" => :high_sierra
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
