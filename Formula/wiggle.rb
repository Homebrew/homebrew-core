class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "https://neil.brown.name/blog/20100324064620"
  url "https://neil.brown.name/wiggle/wiggle-1.2.tar.gz"
  sha256 "31375badb76a4a586f2113e49d13486dbc64844962ae80976a81c6542e901622"
  license "GPL-2.0"

  livecheck do
    url "https://neil.brown.name/wiggle/"
    regex(/href=.*?wiggle[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "840be63d300983f3cc1b04b5d2684ba86e7942bd3a9c46cb832dfb67906f4de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6cc3d15756ce45cdf194123d33103f098f2d1c1ea14a0e32731dd4bfaa3f1ec"
    sha256 cellar: :any_skip_relocation, monterey:       "814c0133b6a6617b027c2584ba6395c10d316a0d3a65b959291477d1e0a31b6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "db474825c0242b8557438ba22b48d18b326c0612ac1bc19ec40e08bd5529cf25"
    sha256 cellar: :any_skip_relocation, catalina:       "ebf56026e29b37067218ad4ee2340de46df5b454b46848a0fe2ac117442cfce1"
    sha256 cellar: :any_skip_relocation, mojave:         "6971993e24c3267d64110bf8ef472bb80db7268a0b85617d3846b66c5f5dbde1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5fe1b56648deb49456c668a2e99d3f7bbb2edf3045d8d55f78382ea008f640d1"
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end

  test do
    system "#{bin}/wiggle", "--version"
  end
end
