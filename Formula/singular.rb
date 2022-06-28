class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/src/4-3-0/singular-4.3.0p1.tar.gz"
  version "4.3.0p1"
  sha256 "9ecf2228c9238d23456b8ffbe60b1b8d20f6f45b36e7af0ab2945e80d7c86e9b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "80ce289ac5c79971b65fdf18c5a6c6b78c0c44b3636363949edf8cc58566e515"
    sha256 arm64_big_sur:  "4bceb33eeb74adaf30b05c1d610aa72e64fb2b8f681f9f24f434c8e8c06c6e6e"
    sha256 monterey:       "3af817e502d089fbaa2d83a327def367b22c6b27b2456cc5888c8b3539ece1be"
    sha256 big_sur:        "ce8293f8d6be94c237d9d07d84ef8e79c48c1cc77b3f4d309e79090632108736"
    sha256 catalina:       "37f0b59b850a0fedb28369a1e406062205fa827aa137d4b5c1f86f02849ec7d7"
    sha256 x86_64_linux:   "d1a5dc4656506176c8794108e42717b7f8774fd6924c32296c67d727b54bcf4d"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.10"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autogen on macOS so that -flat_namespace flag is not used.
    system "./autogen.sh" if build.head? || OS.mac?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.10"].opt_bin}/python3",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
