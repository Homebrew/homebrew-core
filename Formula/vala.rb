class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.0.tar.xz"
  sha256 "15888fcb5831917cd67367996407b28fdfc6cd719a30e6a8de38a952a8a48e71"

  bottle do
    sha256 "ce3464c39a85a556ec30584892c006587c50d9fc4d2c9db90bb8f9367e404256" => :high_sierra
    sha256 "be679c61c3f51c64775540ccbf3506fa3221c5c7a5e1c57c5431e013ac70202d" => :sierra
    sha256 "5d938313296c0a61435fd91f78acc394941c53cc8c96a2eda492c754b86d03a9" => :el_capitan
  end

  depends_on "pkg-config" => :run
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
