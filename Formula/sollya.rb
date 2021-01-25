class Sollya < Formula
  desc "Library for safe floating-point code development"
  homepage "https://www.sollya.org/"
  url "https://gforge.inria.fr/frs/download.php/file/37749/sollya-7.0.tar.gz"
  sha256 "30487b8242fb40ba0f4bc2ef23a8ef216477e57b1db277712fde1f53ceebb92a"
  revision 1

  bottle do
    cellar :any
    sha256 "c4bfa257d2e396ec055f3032d5ece3753d47f582db360d2f5c639d5d21304bc9" => :big_sur
    sha256 "e85099273aa58bed86a2f3f5cecd630d6ef34733eb82781db493baf17e3beecb" => :arm64_big_sur
    sha256 "2a005ddf4e5215f870f20efd84297d27d7683b5acc5ff771545893cf729da2a4" => :catalina
    sha256 "711853a4670a2951c6160f5681c8c511136f3f731e7a7806dd4a9f39b3eff209" => :mojave
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :test
  depends_on "fplll"
  depends_on "gmp"
  depends_on "mpfi"
  depends_on "mpfr"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"cos.sollya").write(<<~EOF)
      write(taylor(2*cos(x),1,0)) > "two.txt";
      quit;
    EOF
    system bin/"sollya", "cos.sollya"
    assert_equal "2", File.read(testpath/"two.txt")
  end

  test do
    (testpath/"test.c").write(<<~EOF)
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
    pkg_config_flags = `pkg-config --cflags --libs gmp mpfr fplll`.chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-I#{include}", "-L#{lib}", "-lsollya", "-o", "test"
    assert_equal "pi", `./test`
  end
end
