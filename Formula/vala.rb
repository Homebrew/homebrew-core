class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.1.tar.xz"
  sha256 "96a8c1415c6484d7d6b837ae263af7c50465c7423bfc8eea5046f3eadfa42fe2"

  bottle do
    sha256 "4be8c08b2f9a061c8a1cc24a21fece9671ce24d4f9dd8a6bc6d197ab23f5f347" => :mojave
    sha256 "9e05e19a2e87cb302dea1a3dfe94b876af3f58218f86dc31a5b4bf6e7f129efa" => :high_sierra
    sha256 "a1ac9227d7c2311ff44aa62e43c669e7364a86fc3e287b093e3191794b096619" => :sierra
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
