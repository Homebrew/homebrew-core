class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  url "https://sourceware.org/pub/valgrind/valgrind-3.27.1.tar.bz2"
  sha256 "5d589152eb8071c02feab8ce6ab719e431a1fbc3e2b1700f5432632a8b9264dc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceware.org/pub/valgrind/"
    regex(/href=.*?valgrind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "a9ca55bcfeb4f0730997f4f89044a75f31f5423d6bc1a35da920329d3867f3f7"
    sha256 x86_64_linux: "8be2699653b4e3be2c2cb9fc407807eb38c334f8d0f81dc94d1e9edb03dc54d2"
  end

  head do
    url "https://sourceware.org/git/valgrind.git", branch: "master"

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
