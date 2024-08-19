class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  url "https://sourceware.org/pub/valgrind/valgrind-3.23.0.tar.bz2"
  sha256 "c5c34a3380457b9b75606df890102e7df2c702b9420c2ebef9540f8b5d56264d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceware.org/pub/valgrind/"
    regex(/href=.*?valgrind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "ec946434ff0bd9aef26966875b372c72276c640196ce7bb0e4f938ab2ccf64d6"
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
