class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.6.tar.xz"
  sha256 "ab9f1756af7460aa1e39c9a7388f5492a4252a3cd9c76b02f2033f1dedcd793a"

  bottle do
    sha256 "c5d7391d7458104a8059caf0224a0dce4c7d17396ca094b796fa257784ddea9d" => :mojave
    sha256 "daa34ed1df32a6af65884d108ff6fe12113f2cf1a4380b9e01e52128508e504c" => :high_sierra
    sha256 "cc70774b22fe76c7020ea69f5c6029ead766b8a3d929699c77437b3fa3762569" => :sierra
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
