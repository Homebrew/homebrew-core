class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.25/QuantLib-1.25.tar.gz"
  sha256 "0fbe8f621b837b6712d74102892a97a0f09e24a55a34dfc74f1e743a45d73d1d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a21f9c9a57ac00426900513351f681cef8b4a0d5f21a58b53e2e9bb3fdd6e59e"
    sha256 cellar: :any,                 arm64_big_sur:  "21d08c80010318d913142d8223b4a6c2a0e61da5dc464442d8f5a7826d3c6a87"
    sha256 cellar: :any,                 monterey:       "2a4f3085b8c67f4964e0484fd868ddb22a03a5737c3b383dc978cfed6f2b283a"
    sha256 cellar: :any,                 big_sur:        "db8251c69b975e90cce845c32bc4f93005322f1f3f2d891ad345b28b57a86245"
    sha256 cellar: :any,                 catalina:       "68bbc43222846326aaf709483a1b3695deaa1f63408bf0cf71398b1d8fdefd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756c52d4d5b4156b87eb9c0706b2e83e0c9046b9f40cf2b9d2859d30c835f56a"
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
