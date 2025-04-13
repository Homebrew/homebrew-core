class Sollya < Formula
  desc "Library for safe floating-point code development"
  homepage "https://www.sollya.org/"
  url "https://www.sollya.org/releases/sollya-8.0/sollya-8.0.tar.gz"
  sha256 "58d734f9a2fc8e6733c11f96d2df9ab25bef24d71c401230e29f0a1339a81192"
  license "CECILL-C"
  revision 2

  livecheck do
    url "https://www.sollya.org/download.php"
    regex(/href=.*?sollya[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c65c8b258fe962a56c94a4e36af2bb30541289140b81a4d9503278cc8aeac144"
    sha256 cellar: :any,                 arm64_sonoma:  "e04b5831f6e8ead9121935f1e6ddf55821d68da7ae5370347063c2e832ec7c21"
    sha256 cellar: :any,                 arm64_ventura: "7fe203ca548328e6cffb2e6d963d00cba80e9842b4c1b71f43ae9b1fcb4b27e6"
    sha256 cellar: :any,                 sonoma:        "2c83c3d2bb45f3b7e16c96530a6a72b114db18a81c7b4c71db50e47c385e6815"
    sha256 cellar: :any,                 ventura:       "ba802f6fe9e582b5fb012aba5c14b69e8ab8586ac5c2d3e02d8f290ebedc64fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34dce0bd22536f4136ca5a874480f1ffe4228f86ba584b292af23c64cbc80ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e1b7f081dcf28664b497a41800a3eb455cb3ce7a4676ff651e06d67cbe6142"
  end

  depends_on "automake" => :build
  depends_on "pkgconf" => :test
  depends_on "fplll"
  depends_on "gmp"
  depends_on "mpfi"
  depends_on "mpfr"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"cos.sollya").write <<~EOF
      write(taylor(2*cos(x),1,0)) > "two.txt";
      quit;
    EOF
    system bin/"sollya", "cos.sollya"
    assert_equal "2", (testpath/"two.txt").read

    (testpath/"test.c").write <<~C
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
    C
    pkgconf_flags = shell_output("pkgconf --cflags --libs gmp mpfr fplll").chomp.split
    system ENV.cc, "test.c", *pkgconf_flags, "-I#{include}", "-L#{lib}", "-lsollya", "-o", "test"
    assert_equal "pi", shell_output("./test")
  end
end
