class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_monterey: "daa3c262b5f625970ea90224a3ce51d5f31cb4768d6a743c880668cfb90717b7"
    sha256 arm64_big_sur:  "8e89022ae000f049ac34f4e2f886faf94204e37b70da7e1b15f38c7b3d4a8f24"
    sha256 monterey:       "4240152e303babaf8e156be70d0b9cfd775ac14b001367f563b055e0aeb6dc2e"
    sha256 big_sur:        "549b28626170548e9def8448a09f4bb1854900652ef802672a30f691a9b44a3e"
    sha256 catalina:       "6435d295ad77d012c577005b1758b3be3ae11b51f0f5d257c0f59f79e227575e"
    sha256 mojave:         "74ed5acd47ee9fa82ba79c276eb996adf6f49dbb17e917dc02bec3e348cf7cd8"
    sha256 x86_64_linux:   "27f94a03a1c3fda8820f6ce864ea4b3278600073eb0e9e258efc8ced07d5c088"
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
