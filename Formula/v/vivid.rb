class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "88db6158dad60aba66ae16f2cd1b09f515625940a33bada65da5562a03538e49"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cead0da902988950326a5860ac608c02825268ad1671928e3e4cdc29c15b4ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2304e6f41c313ba88b3c3cc0677ec82d501b5929e2b793afe99326ee5b4dcb71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9428a55dd427e7f69fd5d2bca9ce9ed2facc3f9a46dcb88eef94c2262ef16fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b836a81f247fdbbfdb40cdb637b8da247189d6bdcd47d12fef66c8e45782bd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560ecb779c10ccaef4b429f834b9003a105e6624336ef79547a131479ecc378e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6de93d50a62ed34f7b448db4620a765f2084ba538b611c0cffa45ccc3be4c0ba"
    sha256 cellar: :any_skip_relocation, ventura:        "21e4d0ad3a7c823273dccbb76b0de6769eabc4b4623e69416f0624468e45ab4c"
    sha256 cellar: :any_skip_relocation, monterey:       "457741bc68092d77ae065c74392404f8a1fb401b6e9aec6a07bf77b61fd89f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bf00f818ea1317ee924a71ccc69204143400762fa5b35b673f64f3b0caabf66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ad36619ada9c224b6f245fed8f79cf39b69e343d223917bd816a1fa873bcdf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
