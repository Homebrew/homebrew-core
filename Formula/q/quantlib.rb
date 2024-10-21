class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.36/QuantLib-1.36.tar.gz"
  sha256 "a0eff3d420cc26c21ab8e55d3fd169448abe631a0fbc9f528a6ac444227824fa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "582ac61a2c62b15be5b6384f1bae16e25108c8ff826b6109139354669e5a31eb"
    sha256 cellar: :any,                 arm64_sonoma:  "c449fb9bd249c3bc6dfe9bbfbb8a07a8223e875e74a666849b286e9887abbc93"
    sha256 cellar: :any,                 arm64_ventura: "bd9a462fc529da886edc64e788862958826f3792738bd1ad9996513841b9e1cf"
    sha256 cellar: :any,                 sonoma:        "826ca8c59eab8a54e9c03a68fa9b77ec8bf6f85b6abd10cd772392cbbb3ad739"
    sha256 cellar: :any,                 ventura:       "0726cb0d7dad1a8418a7b1fda8d699868445adc670a058388b7df7cd433d134b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8effc67b3054d9b5c03c9c4426f7dcb350b4fdccc142ff67994e2d4ae9540c"
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
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
