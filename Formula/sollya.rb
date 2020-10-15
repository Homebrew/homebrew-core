class Sollya < Formula
  desc "Library for safe floating-point code development"
  homepage "https://sollya.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/37749/sollya-7.0.tar.gz"
  sha256 "30487b8242fb40ba0f4bc2ef23a8ef216477e57b1db277712fde1f53ceebb92a"

  bottle do
    cellar :any
    sha256 "ff549e2fff8c593449a7bf92d2d2d7ff423c6a40885838d5be4d7852308a4b28" => :catalina
    sha256 "5a3569111ea2936599668fc075a146ebfd01f471613b7c695a6a3d031ea6a309" => :mojave
    sha256 "5b5b3762879216a04a4fbcea2fa5407dddb331510a9e01f768d684ebdcd99c66" => :high_sierra
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
