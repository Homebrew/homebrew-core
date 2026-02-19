class Sollya < Formula
  desc "Library for safe floating-point code development"
  homepage "https://www.sollya.org/"
  url "https://www.sollya.org/releases/sollya-8.0/sollya-8.0.tar.gz"
  sha256 "58d734f9a2fc8e6733c11f96d2df9ab25bef24d71c401230e29f0a1339a81192"
  license "CECILL-C"
  revision 3

  livecheck do
    url "https://www.sollya.org/download.php"
    regex(/href=.*?sollya[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3da627c992a35dc3af1daf6c84f1e74485277155ebb5793e10a7a68dc2f12a3"
    sha256 cellar: :any,                 arm64_sequoia: "0fc18b3fff4949b1a139a30bcc8e2ab3e08df265b45d4d9a1221fd50e0e35ec3"
    sha256 cellar: :any,                 arm64_sonoma:  "6c5c7c03cc7fd565f55c423cbc69f1050ec019074b9823e3618ed70b94cacc7d"
    sha256 cellar: :any,                 sonoma:        "b623d5218033d5f33a5b370b4f27ceab4177326cf7b3d71660ec2492d2818a95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d25abc81dc57e49af305df1244e0c9fed2e6d5dfc2ef779bc021e02aaad81b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3828e3be08c6b06af99a2c95fc5aa52d2ab5554ec2c79a62b2b4e557e52e11"
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
