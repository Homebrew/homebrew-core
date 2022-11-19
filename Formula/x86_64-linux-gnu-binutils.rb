class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "f5cacecde97d7d3e26842d799008d18cd8fe4153a7555d650494724f9571510c"
    sha256 arm64_monterey: "1fe9f7c820b0669dedafd8e5aad15c3c162fc0e99140156d1f07dd6d56c9811e"
    sha256 arm64_big_sur:  "1429ea522bf485ac5faa58e900c295054a381a320e1aaa6d0c3b8d759eecab70"
    sha256 ventura:        "9d54c8a44903d2abf3dc1f56bdf8285606de14ac709b0b0c44d8112dcc549d4b"
    sha256 monterey:       "7ae4d4241e69368b425188f4a086ea08b6f6effb93e3ec0a5c48302b7236774c"
    sha256 big_sur:        "cf9c2f6587af7ccfc80d8980371524592804f52bbcb0230b663545272e16f706"
    sha256 catalina:       "d29d967719dbf5c432c7f272633bbc2b865a782329c24ce7aca91185947ea6e0"
    sha256 x86_64_linux:   "6f26e684578b2e64500edf2339578a12e9212560fd1935aabef4741ab7170aa2"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    keg_only "it conflicts with `binutils`"
  end

  resource "homebrew-sysroot" do
    url "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain/2028cdaf24259d23adcff95393b8cc4f0eef714b/debian_bullseye_amd64_sysroot.tar.xz"
    sha256 "1be60e7c456abc590a613c64fab4eac7632c81ec6f22734a61b53669a4407346"
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "x86_64-linux-gnu"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib/target}",
                          "--infodir=#{info/target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--disable-nls",
                          "--disable-gprofng" # Fails to build on Linux
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/x86_64-linux-gnu-c++filt _Z1fv")
    return if OS.linux?

    (testpath/"sysroot").install resource("homebrew-sysroot")
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { printf("hello!\\n"); }
    EOS

    ENV.remove_macosxsdk
    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot", "-c", "hello.c"
    assert_match "main", shell_output("#{bin}/x86_64-linux-gnu-nm hello.o")

    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot",
                   "-fuse-ld=#{bin}/x86_64-linux-gnu-ld", "hello.o", "-o", "hello"
    assert_match "ELF", shell_output("file ./hello")
    assert_match "libc.so", shell_output("#{bin}/x86_64-linux-gnu-readelf -d ./hello")
    system bin/"x86_64-linux-gnu-strip", "./hello"
  end
end
