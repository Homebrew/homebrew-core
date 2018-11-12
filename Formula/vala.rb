class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.3.tar.xz"
  sha256 "5fc73dd1e683dc7391bb96d02b2f671aa8289411a48611a05265629e0048587d"

  bottle do
    sha256 "6bdece14d41b29361b2980ceec80bbfee9339559d4e693da8ab413cd8bc67a7f" => :mojave
    sha256 "358e8821ab2bc0a4544546a0f3d752ff8cdb8409b523fd1c73d1edeacbf5fb68" => :high_sierra
    sha256 "c781eaec3be5b22ca61e901e0ac2e6ebb2dbbf0059016cf7c10cb447996b4b24" => :sierra
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
