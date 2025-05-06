class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "faa3952d432ab4c0325ed6e4669d7a011fad1cf7456ad6fe601b529f4a9ac7ef"
    sha256 arm64_sonoma:  "b5f6ffd04e5be4cd62bec37fa2d24a7e7e3e3a9b41eda9d110db859b0c2bafe1"
    sha256 arm64_ventura: "307f3d4dc7a9463a65c413347bfcaa0c27bb54adc719607ff9e0877fbfe8aad2"
    sha256 sonoma:        "1936a59631f8b412803bf7638e7618059bff6cd497a897fe688c64c883542579"
    sha256 ventura:       "2d2bb31be008b9d808ec00d9ef7fec9012a433d6e52c5edac0e0de5501f999ce"
    sha256 arm64_linux:   "42d83c9e9e34493d095782edaa22aa9e88270a02bf085952d4dd2f79990304a2"
    sha256 x86_64_linux:  "fdf58cac64006b3e62bb182b82fb440c9b623311928818375c50f326f188fe76"
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
