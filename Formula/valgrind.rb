class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.15.0.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/valgrind-3.15.0.tar.bz2"
    sha256 "417c7a9da8f60dd05698b3a7bc6002e4ef996f14c13f0ff96679a16873e78ab1"

    depends_on :maximum_macos => :high_sierra
  end

  bottle do
    sha256 "7869473ca1009d871dfcb496cc4d08e0318315d18721854ef42960b76e2ef64d" => :high_sierra
    sha256 "5ac984d472025c7bbc081e3be88b31f709944cf924945ebe85427f00d7cca73e" => :sierra
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-only64bit
      --build=amd64-darwin
    ]
    system "./autogen.sh" if build.head?

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    unless MacOS::CLT.installed?
      inreplace "coregrind/Makefile.in", %r{(\s)(?=/usr/include/mach/)}, '\1'+MacOS.sdk_path.to_s
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
