class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  sha256 "61d684f0aa5e76ac6585ad8898a2427aade8979ed5e7f85492286c4dfc13ee86"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "355c21c82fbd32964f9cef8182adb2040c966468a3389520f4cf5f89c697b510"
    sha256 arm64_monterey: "48ea5e83c8f2d6b590ca04f0c86c63ae5797e22b8f03b00ee89a576544614731"
    sha256 arm64_big_sur:  "aa9ad5cb71fc49aac1fc0295af5d660bf0d2145314f6dc1983d92251d9756a51"
    sha256 ventura:        "04022a0d837a842e7de40efcafa14d69ec287149e2964e2d0a28558640d9f094"
    sha256 monterey:       "d5c94d285aefe5387119ca61b938cc3420eab9c524419ea0d2cdc66ef7b7e197"
    sha256 big_sur:        "a9214ddbaa508e051426c58a21ff65b74d798234cbba8922c57f545c58952985"
    sha256 x86_64_linux:   "31462b4a4bb033602935743840cb211e4944b21ed64d49a190e65ff15b38bfa0"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"

  def install
    target = "x86_64-elf"
    mkdir "x86_64-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-as",
                             "--with-ld=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      (share/"man/man7").rmtree
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-x86-64",
      shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
  end
end
