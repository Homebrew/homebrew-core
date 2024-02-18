class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "df674d0488ecc229a6acf4f6dac6a60c89699fb9569515c5cec6c7d3aea2b3c3"
    sha256 arm64_ventura:  "010cebe94fb852041b6525bb26ecf18da50a2b31ecb2ceea10fa98227268840e"
    sha256 arm64_monterey: "9c4199cbf3a55f3d188ab4ec3d5db6ce928290aabc4f5f53989194b7b8572c0d"
    sha256 arm64_big_sur:  "a291ee8500e3560ac26e38fafb8308aceddcbcf1eaf65b7e8eee887878d4eccc"
    sha256 sonoma:         "529f87bec9d1aa5ff2e47cdae009eec581acb298f0e2ac2dcc5697196d60b6ca"
    sha256 ventura:        "06f5dc90759c05d5bc014a21db08baede43cbb692432a62dfa2fe20f21497b33"
    sha256 monterey:       "73bef350abe7f078fe0d4b63f8ae5638d39e195087f42ca5ddb07ad416273b79"
    sha256 big_sur:        "4adfdb6b0912649db5994bae962666899d7dcfaa22e0def62df966d9b54d24a4"
    sha256 x86_64_linux:   "d4da1645f7d46091e033e896b50287702deb160a41378cb115d50d0fbe8e7e61"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-elf-binutils"

  # Fixes std::log2 import from math.h on Big Sur and Monterey.
  # Already included upstream for next release. Remove on next release.
  # gcc/config/riscv/genrvv-type-indexer.cc:118:30: error: no member named 'log2' in namespace 'std';
  patch do
    url "https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=87c347c2897537a6aa391efbfc5ed00c625434fe"
    sha256 "470f9cd51f0ad5d6b7b8dc080f3d4830a8ae640257ed6fccc61bd46287798eb0"
  end

  def install
    target = "riscv64-elf"
    mkdir "riscv64-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-as",
                             "--with-ld=#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-ld",
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
    system "#{bin}/riscv64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-objdump -a test-c.o")
  end
end
