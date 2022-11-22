class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.28/QuantLib-1.28.tar.gz"
  sha256 "32de9fba5d64c26d2a592ea14f4a895706338befed8ce72de727084a2de68cfd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "948ff0c14704eaa85be10d1dfe5907323156776124f53e6d95e47c0ac30b0cdc"
    sha256 cellar: :any,                 arm64_monterey: "0d2ea8334ca9359323c17a7850fb251d95d01055c53445521d7e440dd1759019"
    sha256 cellar: :any,                 arm64_big_sur:  "ea8db92b697759668a2c4f2dc6a835b0cd191cd48a50a7fb3fc357b93c2542c3"
    sha256 cellar: :any,                 ventura:        "216f4ea89e57d2101dbc7d947ff69eed635d19f19a2873a6844ec944df9477a9"
    sha256 cellar: :any,                 monterey:       "24f0e96fcd9f7bfc0da0b4f4ca4d488198f53379e07d0578426f49e61ecfbf1e"
    sha256 cellar: :any,                 big_sur:        "bfe965bc15765e12f1a0f7213f91c5e361685832102c2757d1fd4a9761ab310a"
    sha256 cellar: :any,                 catalina:       "489e04d6b019692996f2e947df5078a95533c8dbfa5bc350c29b8b34d4a3f8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a249181d841cf65facc43ba2629d3e532fa6a77d899c4a3d91018a22bde7ce3"
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

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
