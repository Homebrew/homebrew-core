class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "223d29d6086c752bfc0554b274128f3d297823b46e1dde252eea3f6e53e56509"
    sha256 arm64_big_sur:  "56f0035c31cef9e4615a2ff826dc9d558129e9afcd200fcd3e4fd5a391d71964"
    sha256 monterey:       "4e08215e432fcd44f3bbb74327862db039385b566e31e45c4273cb56ecb7e5d0"
    sha256 big_sur:        "ae3121942835a7ae4c30164b45b2ef2dbfece6d04bace39fafb6303d07ad5c6d"
    sha256 catalina:       "8f95026e6fcef4786b57d1dac24d3186ff02eb1aa7cacca7c660c02568c5d936"
    sha256 x86_64_linux:   "1103fb3fe9abe92e3e3089115249ce61ec311d3a159997b9c6f2039e641e9036"
  end

  uses_from_macos "texinfo"

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
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/x86_64-linux-gnu-c++filt _Z1fv")
    return if OS.linux?

    (testpath/"hello.c").write <<~EOS
      void hello() {}
    EOS
    system ENV.cc, "--target=x86_64-pc-linux-gnu", "-c", "hello.c"
    assert_match "hello", shell_output("#{bin}/x86_64-linux-gnu-nm hello.o")
  end
end
