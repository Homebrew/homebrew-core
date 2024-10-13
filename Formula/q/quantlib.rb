class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.35/QuantLib-1.35.tar.gz"
  sha256 "fd83657bbc69d8692065256699b7424d5a606dff03e7136a820b6e9675016c89"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3a4137bbe19c41edfd8e678279293a893191581defe11dc94e0c5ff068aef9e5"
    sha256 cellar: :any,                 arm64_sonoma:   "7d0b2c8b6725b696ef1f07f1ca21d777e4b77e7d99c4feaadc91dfd33d40ceab"
    sha256 cellar: :any,                 arm64_ventura:  "8dd31e9dd6b59b9cae2dc2e8625e5cc69903216e625d81a520f911eb7ae05731"
    sha256 cellar: :any,                 arm64_monterey: "b6b9feeecbf646ec1409915e6a9e6e3b41731007b2503b220b47aa137920646c"
    sha256 cellar: :any,                 sonoma:         "360b8683f968704b67b46ac1bb419b61d280a27b8afc696a55669c7e3a668618"
    sha256 cellar: :any,                 ventura:        "626e06f2c70a53670722598b9d3f318f45bb19d2ff0166a0691320232ec16151"
    sha256 cellar: :any,                 monterey:       "e8ec014692a6a5ee27e7dec5b2ae530cffb2b05de0db215815f981726d914a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9563730bf7451d68ad5f70afae1ca960f2a3f129b71fd0f10c3c3c17a17f5f1"
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
