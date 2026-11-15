class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "834bb6495e645b1983c48076c42eff3b0c6f769a7bbf6084b0de2ab711e861cc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ef36a242003edda3c94f614eb5a099d9b0ee4f1f3d89f419256c1c6ca7d8db8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "179ebdefcf1e5ad4cd8ef8eee61bd13aa889adc9e72d124b1807e01f78f5e6ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb5756c2392cea2b8dcbda597c8d6e397138b71d653888b81d382e5483e99bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6cca3d32cfa82089dfb94dcff71f5230655be217979f00135e086d1e3992f2c"
    sha256 cellar: :any,                 x86_64_linux:      "68b09cb6deebe4ba8d3a5bd348a06d84115b300f823ae5ba3a8cda0c9f39be6c"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
    generate_completions_from_executable(bin/"rush", shell_parameter_format: :cobra)
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
