class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_monterey: "47275223413c4cd2180e54f70b055b298cb1a11f157aeb23a65b1da141d1350b"
    sha256 arm64_big_sur:  "fbdab5cc11ae4c8fae0b13de3311e174da15e57bdc9023efbb17e4833b8ce811"
    sha256 monterey:       "3d36f6b2730f8a3d9f7b4d908401812fb24a9572f5807ae74b5a33a21c6c05c1"
    sha256 big_sur:        "6bf9c3f7676f4a927075c91165270717e251698542fba8e748a9b29e556fff50"
    sha256 catalina:       "fb2524e69f18fdd9a5f28a9c56a83d6792ea9ecf9b7e9c8f4c49f9f2888421c4"
    sha256 x86_64_linux:   "13763c4212ff7085b1f793b76ab18a599c93e258ea3c67ce05db19b28c2d05c1"
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
