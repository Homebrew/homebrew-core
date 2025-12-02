class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "6cba35afe40fc91c061f682552d6d54555cdc0b2542355378e0386eb45e9bfdb"
    sha256 arm64_sequoia: "ceca8ec306dc54b68c0074b74aad473b2057f94cc4cfcbc27dabba604e0a4955"
    sha256 arm64_sonoma:  "5a8fc8f663db03cd1ab061339fd16f32b684aabe0ec579176e074a6824d74167"
    sha256 arm64_ventura: "f4a69d072e2a835e9dd00d6eca8a555107f0f8145d282d2614d2d633b6de972f"
    sha256 sonoma:        "2cf316a08babf8a9d47de5a189077ede89c7cf0f44c0af5e5541f5bd6ff4213c"
    sha256 ventura:       "c733c2ddcd91e90353d7387dd01f2e4cf8b793212befd1c39bbd9ef5862d3873"
    sha256 arm64_linux:   "3cc5509b449398991d5668270aa1b87558739984c5c2cdef5787cd2742448b8b"
    sha256 x86_64_linux:  "6df2988c8f83337254c05e04754c7720d39720d6440afec158a82b5bd161f6ac"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-elf-binutils"
  depends_on "zstd"

  uses_from_macos "zlib"

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
