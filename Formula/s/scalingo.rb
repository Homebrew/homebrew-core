class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.52.0.tar.gz"
  sha256 "bb7af4278f0f1e3e55db38d7f2b5c7ac76df187f96066daf6dc3040f27f8fd18"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbc49e2e6e8009b8c40eed1dd9dd487d856f39e72d2348369fb07ed2ed5d591c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbc49e2e6e8009b8c40eed1dd9dd487d856f39e72d2348369fb07ed2ed5d591c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbc49e2e6e8009b8c40eed1dd9dd487d856f39e72d2348369fb07ed2ed5d591c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec387dd8de3aa61fe1270bb94f963012f503be962db8afb7e32c8eab6e580278"
    sha256 cellar: :any,                 x86_64_linux:      "d2ee14f44ba2325d5fc964196ca41bf508efd6c051d799fffc6e8af19e94a97f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
