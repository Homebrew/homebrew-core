class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "079157c1db32ec1cb662610b44206fb3da875c7d29bebb5e3035a9169109aab1"
    sha256 arm64_sequoia: "52a4380323261ec7529b819696d5599c327d1efc19f135c8b2749ce35e7e4cfa"
    sha256 arm64_sonoma:  "9f2df1b8a4a476b5b1b513dc9622910a8e4de57122acd79551c443ec632f1440"
    sha256 arm64_ventura: "82e44af6926993fe3a51ab305e1f82e0080e6f44db0d3cbbb861290711095bcd"
    sha256 sonoma:        "ccb5d01c00355812264ba5942ce37c6bcb79a2ee3b5b8a5fe177f47516af070e"
    sha256 ventura:       "cca64053df220e3966dd7c2695c77e65f5f5395fa5b889ffb8c5ac9933f065f5"
    sha256 arm64_linux:   "443b7eef61d681d7b1231f7ebc3ecf85893a7da3a2047ef1dbda2fc909a11e5c"
    sha256 x86_64_linux:  "f8d1ad01fc135fed522a178bf2fecb8efb47cdf080c4bf7d7e851c3deada1c80"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"
  depends_on "zstd"

  uses_from_macos "zlib"

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

    system bin/"x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
    assert_match "file format elf64-x86-64", output
  end
end
