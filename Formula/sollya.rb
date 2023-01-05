class Sollya < Formula
  desc "Library for safe floating-point code development"
  homepage "https://www.sollya.org/"
  url "https://www.sollya.org/releases/sollya-8.0/sollya-8.0.tar.gz"
  sha256 "58d734f9a2fc8e6733c11f96d2df9ab25bef24d71c401230e29f0a1339a81192"
  license "CECILL-C"
  revision 1

  livecheck do
    url "https://www.sollya.org/download.php"
    regex(/href=.*?sollya[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24c8ad7e4c09b06e16a5eabc7b19ef2a1c7106f5aecc726714ba3cb7d83a4dd0"
    sha256 cellar: :any,                 arm64_monterey: "ab2fae288574175cf2fa8211a355514df71e916d9514b79da9c9836ea7b52647"
    sha256 cellar: :any,                 arm64_big_sur:  "c07fef942ebff9171d52926e76947ad8eeccdc74be40290b18799c7dd67046fb"
    sha256 cellar: :any,                 ventura:        "ff80b9b2a8861e4cf579b3cf016e8c349f15ffe87bad24c4b2e59a51b72a66bf"
    sha256 cellar: :any,                 monterey:       "361f12cad5b11c1107747be6906745e048e9698596e40309d608bf0ae67866c7"
    sha256 cellar: :any,                 big_sur:        "b3a49a1f76957bcbd5a81c8ea141b952b814eb45ff32063451550a7775d9f97b"
    sha256 cellar: :any,                 catalina:       "614701c860f55043408ff5f1d3a6f4d527db39e07ea4f72715b969bacdeb9826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ca886155f71257dd0fa97945db31705c58028169ea4c51f7c8f22631109db5"
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :test
  depends_on "fplll"
  depends_on "gmp"
  depends_on "mpfi"
  depends_on "mpfr"

  uses_from_macos "libxml2"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"cos.sollya").write <<~EOF
      write(taylor(2*cos(x),1,0)) > "two.txt";
      quit;
    EOF
    system bin/"sollya", "cos.sollya"
    assert_equal "2", (testpath/"two.txt").read

    (testpath/"test.c").write <<~EOF
      #include <sollya.h>

      int main(void) {
        sollya_obj_t f;
        sollya_lib_init();
        f = sollya_lib_pi();
        sollya_lib_printf("%b", f);
        sollya_lib_clear_obj(f);
        sollya_lib_close();
        return 0;
      }
    EOF
    pkg_config_flags = shell_output("pkg-config --cflags --libs gmp mpfr fplll").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-I#{include}", "-L#{lib}", "-lsollya", "-o", "test"
    assert_equal "pi", shell_output("./test")
  end
end
