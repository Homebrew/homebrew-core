class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia:  "65d5cafaa2c1489b88380c22897c26de03f89c6848d140951ec3dbe1e268360f"
    sha256 arm64_sonoma:   "e410ed798be5c4ba44d2fb9c4bf9f7506939933380bd52513c2904db67cf30bf"
    sha256 arm64_ventura:  "aac94896e8ef3a894319bbac0b172ff7c1818b43d5d3ee13ce71ebde92ffb9e4"
    sha256 arm64_monterey: "2d39f6758c078920001953818b75794ed4101e3efb21f8a339e911ca12202893"
    sha256 sonoma:         "6dfd845604de9054e5e417ee899c411866b500ab1383a202d7eb7c591117860d"
    sha256 ventura:        "1e9401598b9342ea92ba43d206baecb963b7b351771be382f9e661df84aec586"
    sha256 monterey:       "fa9fb09fe1d3671f5d953321e4795458295d6d29274ce6fb82506a2ef59ae2f1"
    sha256 x86_64_linux:   "5fb43e6c2f02594b826ae95c121159a73fed2e1eee2dfc721af98a694e59d2c4"
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
