class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.7.tar.xz"
  sha256 "bf1ff4f59d5de2d626e98e98ef81cb75dc1e6a27610a7de4133597c430f1bd7c"

  bottle do
    sha256 "940244c9ae563b3f8b4a174015e8ff409a3b4477e75e4bb508172cee060b191a" => :mojave
    sha256 "06a208ad543ef738498697e223e80fe11ab44378cbec2258fc03b92ffe9df7a6" => :high_sierra
    sha256 "afb0cf11ac54de45825fda47f9f9a1bdf64eb903b700fb280262c45e39ee3f07" => :sierra
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
