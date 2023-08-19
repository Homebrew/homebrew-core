class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.31.1/QuantLib-1.31.1.tar.gz"
  sha256 "13b5346217153ae3c185e0c640cc523a1a6522c3a721698b2c255fd9a1a15a68"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fdd80e703612298821f31f2c278f78c72d629727cac272cb86c5e5a7da4edb3b"
    sha256 cellar: :any,                 arm64_monterey: "1a7dacc192c9e2a00ed99c40cc0facfe2bb92cf19508d7d36351783371b03b92"
    sha256 cellar: :any,                 arm64_big_sur:  "01ee485c8a3bf337909e5868eebe03398afc1f1b6ae5dfa08ab8b6653532a4e1"
    sha256 cellar: :any,                 ventura:        "c3a009b596872f95e707f907b55944939518e2adfa02336b7fd49d2c09a88f04"
    sha256 cellar: :any,                 monterey:       "66619bae355c05e0a8b03f153ece4fd73b5830e557f0b9d6e1f125671547875f"
    sha256 cellar: :any,                 big_sur:        "328e3ca951ee9c9f7698f081ec2d20fd568430fa8d47f3fbf6a12d69ebdeb549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb2a3b254492cf1f450cd95bc21cee4084248dd55da1280cd5cf0ad0bf22f81"
  end

  head do
    url "https://github.com/lballabio/quantlib.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
