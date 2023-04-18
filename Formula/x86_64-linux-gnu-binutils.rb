class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "f9a28409dce37f4a63f4c6730eefd2380a83f91a57883f812622c7684ef2ef8c"
    sha256 arm64_monterey: "57f7368fc8f9cee216bf89f6ec79efc7ea76c51de17806887e3ed21fdce5376a"
    sha256 arm64_big_sur:  "0747ea5e5282e342f8ba03513d6b3557910d16df8a094ddeb4982aa13c5102f5"
    sha256 ventura:        "392480cc4326afd89b00c5105ce23692e2d5f104b8fedb9daea54cb385219a8e"
    sha256 monterey:       "03a7b9c231bfa17209693c3b815f6c5a1c30023c30e5133856f45e774847eadf"
    sha256 big_sur:        "5f65086f18dbfb0922c6bc1d5fecd7f746371e282be1bd77030b93326e89c0da"
    sha256 x86_64_linux:   "93bf432220d03a774dab1fe551d315b6734215c116864bbf5bc84d0e92c6fc55"
  end

  uses_from_macos "zlib"

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
