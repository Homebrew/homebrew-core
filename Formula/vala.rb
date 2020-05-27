class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.6.tar.xz"
  sha256 "d18d08ed030ce0e0f044f4c15c9df3c25b15beaf8700e45e43b736a6debf9707"

  bottle do
    sha256 "a6c0f35ad1b503fbad2e8f4574a81e067ded8050ff7b065847286512455f41d7" => :catalina
    sha256 "7935c4d051c492a745bb37cad9368c57f9609e2abe486e7d988ee4ba4cf1740e" => :mojave
    sha256 "2999e2e922de6917c585cc8214afd5861c33c8dff2c9514c626c61e955595334" => :high_sierra
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
