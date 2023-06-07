class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.8.2/sfk-1.9.8.tar.gz"
  version "1.9.8.2"
  sha256 "051e6b81d9da348f19de906b6696882978d8b2c360b01d5447c5d4664aefe40c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b4af119c95b74a3aa4d81f766f27b772ddac04552c7f2943412e38bfabecf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802879c9b035ffa817bb9669964b9870b51d58ee0d60d7c4fcadd01c8320931f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2080416e3567dd55c27b4402804cb46557d17f6cfee5030d5f3817f9df961b96"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6e37cefa626d3abfaba2dca5a7f7c7075b9775753738d31e671bd42764e0d8"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9a01171ea0d006490361bcf684aeee27a304bee44d030016d1b58ec1f75934"
    sha256 cellar: :any_skip_relocation, big_sur:        "1790cd2261fe86b74b312d786ea05530b77e4bbd8c7d49354b0366c1839d0661"
    sha256 cellar: :any_skip_relocation, catalina:       "bc27c409d8ada554b0ae0f4b134a22e8c06ce2e6718a2b4fd5d24b86f7c7c8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b1e299ba428cc5396d6a84cfa3719efa8f75d8ad3d62157af52260db30ae713"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
