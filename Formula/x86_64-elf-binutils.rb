class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.32.tar.gz"
  sha256 "9b0d97b3d30df184d302bced12f976aa1e5fbf4b0be696cdebc6cca30411a46e"

  def install
    system "./configure", "--target=x86_64-elf",
                          "--enable-targets=all",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/x86_64-elf-c++filt _Z1fv")
  end
end
