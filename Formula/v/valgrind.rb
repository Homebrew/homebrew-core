class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  url "https://sourceware.org/pub/valgrind/valgrind-3.28.0.tar.bz2"
  sha256 "9f7a18d128f05d3a80fea53e6953f34aad7200a425ceaee46099a8a798a7dd9c"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://sourceware.org/pub/valgrind/"
    regex(/href=.*?valgrind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "ac0e1eec275ce44731ba1ad2e4921f01c16a69b7694dc0a7d72e19d0e31a5e5b"
    sha256 x86_64_linux: "e69994d21faf757c040a66a31d0ef5700661e813f9b37befcc527d89de0cb5e9"
  end

  head do
    url "https://sourceware.org/git/valgrind.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :linux

  deny_network_access!

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
