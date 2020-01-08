class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.5.tar.xz"
  sha256 "1a7847d2599d902c805a58b95b72b69e64c0223c2f6220163998a7ab4b42db1d"

  bottle do
    sha256 "97a86568e1012c18509f10066f596d94dc4bd7731b189b25807e977046dfd519" => :catalina
    sha256 "9109b8dac9ee72c2edc7fb4379ef14e4c06d1054e59ef595800b4d4816727f98" => :mojave
    sha256 "209aae2d0d9c4d03456a287f4f61939cfd9554791f33f1e239eb9dcf06a3dd57" => :high_sierra
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
