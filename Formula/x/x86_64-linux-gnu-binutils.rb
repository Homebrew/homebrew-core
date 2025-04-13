class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "2f25854d0670553fd5b5306d53e544929d3ae89595e5b04b3784e29fb6a0facd"
    sha256 arm64_sonoma:  "607de283c72bd6b0d7141fed0282051e244768fc907093ac5f6d4d951588dbde"
    sha256 arm64_ventura: "3e90b1013bef3131b597fe612ea8ed2ab7617ddcb0c89dfaa632a1f9c0fecfcf"
    sha256 sonoma:        "0332609f6a0bb2aba6f6eccb6fbddb1afbb5c3242e9cef35358a36f0b4d370e2"
    sha256 ventura:       "675425789a28b7c3dee6165a593e22ada9bc39aad1b3f301df3cd28ab02c11d3"
    sha256 arm64_linux:   "647cb36d34c7ab5fa8df2d5d81b5ff999986d934ed7459c6186ba60572ddec12"
    sha256 x86_64_linux:  "7f98564cb604be445bf6d819ef1baea435e7f3d30e7db1fca6205cbe6cdb8b3a"
  end

  depends_on "pkgconf" => :build
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
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() { printf("hello!\\n"); }
    C

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
