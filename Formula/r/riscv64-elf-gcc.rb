class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "8f7e26c7acdfe47af2a57220b8ad9e2cb220e1056f79523b6c4a3c223bf81c28"
    sha256 arm64_sequoia: "5859b76f78cc98f21915025f04ba2b4c8a35a7355e07ef2f7aa41ecf015d68e0"
    sha256 arm64_sonoma:  "0a186aa320a1da1acb909546646e94722b2438faa6c29c5c2ea95dad01a38de5"
    sha256 sonoma:        "b497e0040c8acaac7f1d7c91f5bcb746e012682f6abf285d0001db0b5bbf0637"
    sha256 arm64_linux:   "2653235f45468f78ecba44b21ee08aafb10cb34cac844193e54fc9eae836cc9e"
    sha256 x86_64_linux:  "b2c02e74ba46baeb8b66e2b192674d40a81d3181c1b4d2b28977834504ae3e5a"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-elf-binutils"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
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
                             "--with-system-zlib",
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
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C
    system bin/"riscv64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-objdump -a test-c.o")
  end
end
