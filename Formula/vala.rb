class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.6.tar.xz"
  sha256 "3774f46fed70f528d069beaa2de5eaeafa2851c3509856dd10030fa1f7230290"

  bottle do
    sha256 "97e54144bb3b93e096dae25aa1dd6dfc7cd9967dbd36c6abd3dd5823cb332f3a" => :mojave
    sha256 "c1ce33e3a66be542f39f84724851c41d7341cd1b99ce5c4a25ecf0c95ecea938" => :high_sierra
    sha256 "0f29ef805b047b66efda22d53b49c02d1b09e5b5f4c8d7eb99dc78afb63ce593" => :sierra
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
