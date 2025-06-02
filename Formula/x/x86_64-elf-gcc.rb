class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "a2ef38ca5207ee7eb12f815392169220a7a24fcf3848ea2fe1f592f315fbf188"
    sha256 arm64_sonoma:  "e1773647d8ed32fb82e6f042ec94b88d162d83e3bdf3330de46264ad6f2bc227"
    sha256 arm64_ventura: "462617b5d54609ef51342a4185bbb657f9fb95e88d7659fdad9a38e4799952c2"
    sha256 sonoma:        "a3be452f8def32721bccd47aed6245510684fe9e0763a5e479900d98590151da"
    sha256 ventura:       "22560f07c1909a4b9a6726c4f3cdaa1a1714f779ca06b71071919daecaff800e"
    sha256 arm64_linux:   "664e2703de6f940cd66281726919d64eb2eb725c4437c0d4707dbcaf2318738d"
    sha256 x86_64_linux:  "819c5510630041d67f2b8f1c3c31a6e18ca4b664d6a834cb7078ea934d9c12cf"
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
