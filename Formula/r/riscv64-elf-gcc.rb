class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "1818ab9fff8bdb3433f8a14e8837eeb53c51d210caaf1225c8a070c00d4efd8f"
    sha256 arm64_ventura:  "92c258a63f964eda0477351f83960b13a28aa6a8fdd64368c7dc399971c09a18"
    sha256 arm64_monterey: "e97c6dbd93fd8ddd1212ca992a481a34ed9593c2c41564a4480fa257a43ddd2d"
    sha256 sonoma:         "7d8fadfac69d5fc0a9eb3118a6ab26eda4dfb3a1764a481b68f3425f7038dbaf"
    sha256 ventura:        "f48e9911238997a077b4ed18fea24d8f66121fac6974169546244c702d9a8d19"
    sha256 monterey:       "9539f61abd5e7984623bf62194f769dc3734ec68b27d12c89b70458107971c0a"
    sha256 x86_64_linux:   "1dc95e8418bd63f2736cf0b3a47b83ac98f2c993fc8567b1cda47b157ad0e309"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-elf-binutils"

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
      rm_r(share/"man/man7")
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
    system bin/"riscv64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-objdump -a test-c.o")
  end
end
