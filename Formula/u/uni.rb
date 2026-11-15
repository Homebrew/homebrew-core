class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "e9208bc0028d239f9cfbb701d98b14e93eddd138ac6433c6f2f5718244ffa5bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a9b47963c51754df65c9c0c9b2ea8839aac66acd891a7136707a31816caf649"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a9b47963c51754df65c9c0c9b2ea8839aac66acd891a7136707a31816caf649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a9b47963c51754df65c9c0c9b2ea8839aac66acd891a7136707a31816caf649"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04f779299b15c4da69397098d59e624fe52a748300911107eb43f5cb01c746b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "845dc34ee981ad03feff7afde2c246f3e791ee1842806551b55832b54d00beab"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
