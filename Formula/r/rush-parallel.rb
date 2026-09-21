class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "5f38d11af5ab8f3a9cc2c2d30f735bf6372276eba30e27530aa2393986f82a26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05faae588d499214b3a7d958c31387b6a54459347699f4433f42ee6eaa1d7b92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0be6f2eba69e31d3a7c6c39768bf37296896beb0019bdf9cc3381efb2ede0c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2580d07b6d2db3f1386fc34d3c43087e039b2509ca1c3fe661d2342288a58692"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f00ab4e11719982a730770724a019462d91b7ce5e3292fa712c1a9c9baae398d"
    sha256 cellar: :any,                 x86_64_linux:      "de99ab926a9c9d595283b90799f105e7d2ed1dfe0c205a2b1768bf082f05724c"
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
