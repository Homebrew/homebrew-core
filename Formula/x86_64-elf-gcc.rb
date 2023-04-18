class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "5c46b0563610d57bd0908968eb9ea7ea18f6294c54bca2608acff49b97b725e3"
    sha256 arm64_monterey: "48cf54a665c501b6efa720f565758649c1f0ec81169fd283a85113109e414786"
    sha256 arm64_big_sur:  "6fce8fb36d19f1002128e411674b84ae8d5bbd73e30487a0811879273a441360"
    sha256 ventura:        "bd50e6c834cbd4284b971a4fc562efc731e7a9d6ca500de8f5f8edcf76a13580"
    sha256 monterey:       "bf3fbf450237ab38d027286a2ac63019d11f9b785ef3c6f1202c6b07ab6e9a01"
    sha256 big_sur:        "f775d00d861ad6f823d444bef48f0a23c4e7f1aca80d74a2ba7e7b7bf49f4ff5"
    sha256 catalina:       "2dbebb5258e19b39ec7ca9abab06df50ca461dd3b40646694a737609d8e4e32e"
    sha256 x86_64_linux:   "ceb074281119fd98f10171eb30f91f8ed823db696e00bcde7f10f49d3a5c5196"
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
