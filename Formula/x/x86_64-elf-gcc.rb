class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "6d9bc1533a46fc1b5d3d1208332a00cabce0b047ac0245219bf08a28f9169937"
    sha256 arm64_monterey: "31504aa8649a9222cc2a4d76a40d716b650c42265646749eec8ee41e05714989"
    sha256 arm64_big_sur:  "aae5fafb28973f3a7dbc22ed06270db8fb3941e0719f14b8459308b6dec15137"
    sha256 ventura:        "95b46844e430a5b06ac0b8d96aa6b0eedcc761f9295f21b6c6e4557eb181de83"
    sha256 monterey:       "4b6e729c8333d369bfb722d2b08200f363341845dfa48ba544b8848e7096407f"
    sha256 big_sur:        "2c5baa4ec478c1aadaa334e758c6c2fdb6c724b3c714844a5046b5f14450780d"
    sha256 x86_64_linux:   "e934bb734ad257273cd08ab29728c385f09c456621d834b8b9122d3724e7b3fe"
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
