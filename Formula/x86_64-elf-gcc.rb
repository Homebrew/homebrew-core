class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  sha256 "4c4a6fb8a8396059241c2e674b85b351c26a5d678274007f076957afa1cc9ddf"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "85d3c71f6a3a7bd55f14ada1d9ccb10aa655f4938d0a1fc634cceff499860292"
    sha256 big_sur:       "c5e485f635596a59826e07708ccc497cc950503a4711fe83faf9aafa5ebeb914"
    sha256 catalina:      "1a38b6d35a0f39653d753981acc9c256ab2eed8a2c2d5aeafbb392365deebed5"
    sha256 mojave:        "b420339f7f513a1d3df6f296558f1667e0bac2623d7ff6dc857efb9702d86c34"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"

  # Remove when upstream has Apple Silicon support
  if Hardware::CPU.arm?
    patch do
      # patch from gcc-11.1.0-arm branch
      url "https://github.com/fxcoudert/gcc/commit/eea3046c5fa62d4dee47e074c7a758570d9da61c.patch?full_index=1"
      sha256 "b55ca05a0ed32f69f63bbe708568df5ad62d938da0e34b515d601bb966d32d40"
    end
  end

  def install
    mkdir "x86_64-elf-gcc-build" do
      system "../configure", "--target=x86_64-elf",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/x86_64-elf-gcc",
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
