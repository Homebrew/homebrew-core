class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.2.tar.xz"
  sha256 "884de745317d4d56e4e8cede993dc8f04d50cfca36cf60d2f2f278c30c2b1311"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "4439b2acdca47a528c5df4abdff06ca00d786ebbe53ed5044efe46063fba2583"
    sha256 big_sur:       "d50aeb3a81841951fe2878575ecd16eabddfb2d47dec473d0e79a580ddd468b4"
    sha256 catalina:      "959a4649b6b824fce8f63075c6d8d3b9456f4874e5da5793333a55f749a21a49"
    sha256 mojave:        "3b7ed491d3c3c4e6a7967a4ff834ef0844e4ebfb228480c629d9f7a39402f09f"
    sha256 x86_64_linux:  "fb3c6f4345f406a684e942d21f2a9e4a4524bb30e295d4aa52c5350fa5f5a215"
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
