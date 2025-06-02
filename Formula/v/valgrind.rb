class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  url "https://sourceware.org/pub/valgrind/valgrind-3.25.1.tar.bz2"
  sha256 "61deb8d0727b45c268efdc1b3b6c9e679cd97cbf5ee4b28d1dead7c8b7a271af"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceware.org/pub/valgrind/"
    regex(/href=.*?valgrind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "cb51fc8d901c5d11f5c1d8c8fc9ce383f5798e75bed70209a7ab1c1ea40739c0"
    sha256 x86_64_linux: "6b6519192979b46d2f537d04d199c3e521ccc7794eed45f2a7ad97e0e26e5754"
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :linux

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-only64bit
      --without-mpicc
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage", shell_output("#{bin}/valgrind --help")
  end
end
