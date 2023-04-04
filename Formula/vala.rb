class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.6.tar.xz"
  sha256 "050e841cbfe2b8e7d0fb350c9506bd7557be1cd86a90c896765f1a09a1870013"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "ba2f58718d0d2b8fb7a1ae818f7f6d82915eb30e57d7f172e9438b2537beb648"
    sha256 arm64_monterey: "b365a17840262fe16ce8eeb7ceffbd9c65a0af032d88aea634ef3927709f2124"
    sha256 arm64_big_sur:  "3a48c944cdbeda283de946836ae0e5afa42375b0cb01df497182c12a64ef06bb"
    sha256 ventura:        "69b9e4d3338311ee0ce598a748798d8d8aa3cfac03c5cfda971d7193c3b69452"
    sha256 monterey:       "07acb054459602d49980e7380f2042e796aafdfab80543da7042c58d1149d33d"
    sha256 big_sur:        "897c77f86ebaca3a25e261130ef1e4afa2f63e834496d06d8feb7dc9a9acc64c"
    sha256 x86_64_linux:   "bf00e758bdac4f3ac275b9439b02a1ba5ffccac1e8b0b6e42e13de141fc47834"
  end

  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
