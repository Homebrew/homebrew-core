class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "dd420be3f81bac1ac1639d24e3fcef579cc5c5b0fff241e07019bf9bf9affc11"
    sha256 arm64_sequoia: "60a102524f74f12cbcea905af273b9fef6138b0a1b317334e88f1721b973d012"
    sha256 arm64_sonoma:  "a53245a5ba4dc2b7d5e26aff307dffa50b193fe1ed692a922173901b3a484844"
    sha256 sonoma:        "c9706b8f941a2066e9b5c028bc49b5c3a072016ecc39fff13bd2ddf20074ed03"
    sha256 arm64_linux:   "99ce019a819bdc54a7e0bd043246cc659233a6b6ca51e54323d2970554f58e47"
    sha256 x86_64_linux:  "f59b5a8c6e2020aa7c0c4d26dcfbbda6729947bec7e116749f67ca6f13be4b3f"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "llvm" => :test

  on_macos do
    # Requires the <uchar.h> header
    # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
    depends_on macos: :ventura
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"

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
