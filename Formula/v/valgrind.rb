class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  url "https://sourceware.org/pub/valgrind/valgrind-3.27.0.tar.bz2"
  sha256 "5b5937de8257ee8f51698ea71b9711adce98061aa07daa4a685efc3af9215bef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceware.org/pub/valgrind/"
    regex(/href=.*?valgrind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "6aa82a2f55ce276aee655ed2ffbab056217df6a2e530b4d70edc07571b329a9f"
    sha256 x86_64_linux: "9c9c5882d596d87523be1427937a661fcc4a58aaf6085a931ac3d221102edb6b"
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
