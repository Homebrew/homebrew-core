class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.2.tar.xz"
  sha256 "884de745317d4d56e4e8cede993dc8f04d50cfca36cf60d2f2f278c30c2b1311"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "ceeb3986a46df983a1a7214e23495cd5598ef361bf371462049fdfa58aaef159"
    sha256 big_sur:       "15309c367ad3751b17b8e274bbd6afd1f94a5a5aa1b526672c822c60f8d851cc"
    sha256 catalina:      "871355ef358a6133dbaac527150d0ea0904e9e965a4f43c851f11250e177200d"
    sha256 mojave:        "6ab2bde47eb60c760f6696c0e3c1cca03be3b9f93de34251065ba81731faf249"
    sha256 x86_64_linux:  "07e428998840409599525d35796b354873ad6bb45ca2bc6f3d9c89ac54ce6fcc"
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
