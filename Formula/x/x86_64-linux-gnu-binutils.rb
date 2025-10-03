class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "8bcd14fdc5deb4656227cbde3cac9386641b21e644e2358347141fba6fecdcf1"
    sha256 arm64_sequoia: "268ee37eba6e05f6be4f51f5e95920bf3cea41523c1cab284ab09f52ac6c3f74"
    sha256 arm64_sonoma:  "a9b8aa0c3caa2151731989630391b53720210e91ff44bee17d5037b597e2dd6e"
    sha256 arm64_ventura: "fa11644983812158c2e314b59cf7dec333b535e8172f0e9d917fee8ba65e46b1"
    sha256 sonoma:        "28f9353635715f839ae5868f1dab58ff6cc374877090fe5ef3f6ce8787d12774"
    sha256 ventura:       "d352c4509d7f504679a887f289214a13b1e22c78790d817f99a409fec24de610"
    sha256 arm64_linux:   "046752ea89c86cf164c16c62f98c0b4c7244e41351f0bb0d968dd02e68ad87de"
    sha256 x86_64_linux:  "cbd3db60259e28fe23d0682e5d0d6424be817a214e9b745c06676d4bfa0ca790"
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
