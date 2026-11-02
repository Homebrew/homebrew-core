class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "834bb6495e645b1983c48076c42eff3b0c6f769a7bbf6084b0de2ab711e861cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eab4b736ff7eb1e9cb14925d96aba59b223a583dc2dc792180aac43d306e68d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb6f002a589addd810dceb2663befd270ad92ad33f700882a76e40bd67563961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96f33fc2bd4066c03fbdefca93f845a04d28ac6b7ab29c9f3b649ca4f5526d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26f58b0bb493bbc856fb7b5e4fcacba7dcc4e1ceab28b55fb433b586a07c3a49"
    sha256 cellar: :any,                 x86_64_linux:      "ee633c98976136ee360eb728433eb28ae5c133978a99f812017dd1de423b2ab5"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
