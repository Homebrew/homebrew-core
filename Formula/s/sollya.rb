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
    sha256 cellar: :any,                 arm64_sequoia:  "c54e2cc2ef4d7ffc701e70dd86fc4b8af5fbd7caca7b3926e649d35802f7e7f9"
    sha256 cellar: :any,                 arm64_sonoma:   "f2be4f14eb0f2876410793baae2a0116992755d1cfd78437f4e93a26750ddc66"
    sha256 cellar: :any,                 arm64_ventura:  "2f573d2f31f5e3bca82f0d2b3e27fe6b3e20d6b4b7c1a98e7a26cc55d7c2d2f1"
    sha256 cellar: :any,                 arm64_monterey: "77a5e82516a3ef1c359bde51cbc1d1f81eef19dd493e3953e9fdc755a954444e"
    sha256 cellar: :any,                 arm64_big_sur:  "4da855730938fc0b79730ff7cce4e11ea6ede0170b502e02f5ad752d2d5860a3"
    sha256 cellar: :any,                 sonoma:         "8698916c72e332c8fe69ca667e74a8f5ca769737691b4aa48dc44fe555f8d837"
    sha256 cellar: :any,                 ventura:        "b79c3ee6d3a4e75213c6b18cfe6cc9349ef0b7bc70154bd0050e1a498094bbd9"
    sha256 cellar: :any,                 monterey:       "f4602efb57d40817c15305241be91d7861930e5335f45b88199434c8743384cb"
    sha256 cellar: :any,                 big_sur:        "901986bacc46541818bb27dd801a687c4729ed5d7aadfb03694c375f5cc2f714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9160d801c71244d28535d85aafa6dd7a77a1adb4f67e83dae36ddb8f05bad991"
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
