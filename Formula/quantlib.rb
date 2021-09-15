class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.23/QuantLib-1.23.tar.gz"
  sha256 "f6c648dd0f8989e9afde31587bca7b04680fba78d692e626227047c6868420d8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8cd4e5c67f47301e635201022dc4fa34f6506256a03f7c4e34aad916668dac72"
    sha256 cellar: :any,                 big_sur:       "c4becabc004ec62661e971d66f2e018b47ef1cdca1b95b86f88704129a251364"
    sha256 cellar: :any,                 catalina:      "aad302b508044d894983888ed931c358ad3b0c059321a2f981432dbf635dd0f8"
    sha256 cellar: :any,                 mojave:        "cb305d0e8b8d137856bfcac3579d4f9e2ff3e1c621d62719375362a29f679620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d28d98e74c4067b244c61ca862a88df814ff595623eed63af0263154baa9a43"
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
