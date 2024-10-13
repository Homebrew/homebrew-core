class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia:  "5031d81909f9d18d78c5804c97e287ba911d0605ff0f8274a934fe2d947ebecd"
    sha256 arm64_sonoma:   "9cbd8106a4471dd260c8157d3bdac0b31539e3bf45f472d53ffb98a3c873943c"
    sha256 arm64_ventura:  "2a652369a58722b961d41b1d2d8ffcd64229b6afb14efdc4fb3f7a8b2f43b68c"
    sha256 arm64_monterey: "e00daa4dcc0d51798801eeeebbcb047e3d63455ec4985cd2f7300f1eab83cffe"
    sha256 sonoma:         "294d42c13592a0ee389c2a5b5816460d19166b9bf32fc9d1b4b7d1673a370ef5"
    sha256 ventura:        "8efdd8f653e94b0619589d0c488320abd559ae83237372c35654495b9ec77140"
    sha256 monterey:       "bfa49e85eb21fbe29bb59e28281ef0c5861711db6a7b3629439e516080a19e72"
    sha256 x86_64_linux:   "c1c2c11e020c46fdb637a70f7f57070506718b65a894118efad7ffd260c22d18"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-elf-binutils"
  depends_on "zstd"

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
