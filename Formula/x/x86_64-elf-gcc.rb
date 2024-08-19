class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "ecad7069bf10e9468e59c5d017f151521136c4ab5f20842852716c105c0ab665"
    sha256 arm64_ventura:  "e398f983a2de3def6d5be8f0f815bd5b91f7f6a0715d2c162eb2d1a5f69bfaa0"
    sha256 arm64_monterey: "769c5abf684a2b03848fff07e8891d679c8635046a70e7f3bd0b7e47c3c92702"
    sha256 sonoma:         "5a45195baa15feceeffe34990b4eb3440cfb1f5f65ae43a9f276f4b224c37c70"
    sha256 ventura:        "656766e85ff0a824dfcd706fe6835edcde91f2d25b0d565b678cfc7bde6ff43f"
    sha256 monterey:       "2670b8937231692b3a1b211e572b2fd56dc00fc2110bd176743d82c900884404"
    sha256 x86_64_linux:   "4ef344bb4a84ddc89da87ae8ac757ae25743715ff9cd3afbf63861ee51337df5"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"
  depends_on "zstd"

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

    system bin/"x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
    assert_match "file format elf64-x86-64", output
  end
end
