class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.0.tar.xz"
  sha256 "a2df486f8128f5121d18abd9ee6263ea14297007eaf8572904768a7397fbfbd7"

  bottle do
    rebuild 1
    sha256 "edd16c8fd3cfcb6c6d200e355271f91ef0fb2c5d9fa0d4bf63f8da94c77bee2c" => :mojave
    sha256 "bb29b96a10f541c57c0215958b528181a67006ea11eac9153c62837ef39e434f" => :high_sierra
    sha256 "443266d7f747f2eae335c8cd979ebbca9468a8693431826a8b0d859db17efee2" => :sierra
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
