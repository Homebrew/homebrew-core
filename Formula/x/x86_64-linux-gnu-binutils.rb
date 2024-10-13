class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "bed40fd4b54c0a3cac51aa71585f5cef24d464ea3c38afa01babbd1f05df11a3"
    sha256 arm64_sonoma:  "60cafd9e4c28e6224c899a455dd892910b4c24a46e6d64a9d53f876a054d8a24"
    sha256 arm64_ventura: "7d075d3cf521e48d0480327318070e3de414fecfff5bce1637ad47ef9dac3404"
    sha256 sonoma:        "9e63513d5d2a0b82a1cde53be02aee5a14214897a184db0af6fbde6c904bed94"
    sha256 ventura:       "2d5d7f1330758c0a0d9a3a3580bb265f0db51390c1f27a815ccbcf55bb548927"
    sha256 x86_64_linux:  "28b05e9d5c0673be09dedcca3f2f9664b65a59d4c65a2aa9dff2fb6c8e9a4712"
  end

  depends_on "pkg-config" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    keg_only "it conflicts with `binutils`"
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
                          "--with-zstd",
                          "--disable-nls",
                          "--disable-gprofng" # Fails to build on Linux
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-sysroot" do
      url "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain/2028cdaf24259d23adcff95393b8cc4f0eef714b/debian_bullseye_amd64_sysroot.tar.xz"
      sha256 "1be60e7c456abc590a613c64fab4eac7632c81ec6f22734a61b53669a4407346"
    end

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
