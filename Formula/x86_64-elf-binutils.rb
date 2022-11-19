class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "ea4e67219572675d602486abbd9b41aa0f72548d0abab02d13ca4b7e537366a2"
    sha256 arm64_monterey: "eefe767e1d8a366b16f89c976825568e19e0965da3f3721672ef8391242acfe7"
    sha256 arm64_big_sur:  "875ed5414b3fe9aff66a53bc2fcf61e456d9ecb7cc5307cb2c4dd46b4b03d423"
    sha256 ventura:        "c24b4d9fe4626682dd01a7353eb467a21ddb61970a494160a71fa36c0049d6b3"
    sha256 monterey:       "3293e496ede109f8052ea76ce461c670b85b4675e6b27c6c394071915ea69323"
    sha256 big_sur:        "47da0e5bee1e895671c003662d563f8940082376c5ada8f3dc76e0a8c79ef7da"
    sha256 catalina:       "fee28befc1cb766febab4905bfe64d3c1a8b2273e0161abe25ee68cbf5306ca6"
    sha256 x86_64_linux:   "9ebf98d717a55e400447bebcf98d6143e8c8f8fcd8affd3912fdc04cbb85547d"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "x86_64-elf"
    system "./configure", "--target=#{target}",
                          "--enable-targets=x86_64-pep",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/x86_64-elf-as", "--64", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-x86-64",
      shell_output("#{bin}/x86_64-elf-objdump -a test-s.o")
  end
end
