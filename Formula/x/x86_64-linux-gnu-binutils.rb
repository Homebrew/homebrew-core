class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "6eeeaf18ed0b9b7de6b4434860c4e3fde345d644ba355576376001c5df2dc7c9"
    sha256 arm64_sequoia: "56d4c8cab30bbdadb17e1bbb9161967e6fdf0e8d93f259a470fde21852cd3332"
    sha256 arm64_sonoma:  "3baa77d451f0a0ad0dec60030f24a298728169fed6baa842a305758f24487f80"
    sha256 sonoma:        "7a2a3b16806b738f6bcfc8a6ad04e160e7c7bc6b10ef4fff7c34fa775a3e9702"
    sha256 arm64_linux:   "77ea2c44e471fcda177c214b51f9bc3d6faec4ea48eebf8e075e9dd7563ef203"
    sha256 x86_64_linux:  "1f5bc4d066a4613ea870a44754c887a8d471df143fe357fc9099678ae9746e48"
  end

  depends_on "pkgconf" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
  depends_on "zstd"

  uses_from_macos "llvm" => :test
  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    on_intel do
      keg_only "it conflicts with `binutils`"
    end
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

    (testpath/"sysroot").install resource("homebrew-sysroot")
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() { printf("hello!\\n"); }
    C

    ENV.clang
    ENV.remove_macosxsdk if OS.mac?
    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot", "-c", "hello.c"
    assert_match "main", shell_output("#{bin}/x86_64-linux-gnu-nm hello.o")

    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot",
                   "-fuse-ld=#{bin}/x86_64-linux-gnu-ld", "hello.o", "-o", "hello"
    file_output = shell_output("file ./hello")
    assert_match "ELF", file_output
    assert_match "x86-64", file_output
    assert_match "libc.so", shell_output("#{bin}/x86_64-linux-gnu-readelf -d ./hello")
    system bin/"x86_64-linux-gnu-strip", "./hello"
  end
end
