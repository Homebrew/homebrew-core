class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.52.0.tar.gz"
  sha256 "bb7af4278f0f1e3e55db38d7f2b5c7ac76df187f96066daf6dc3040f27f8fd18"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0362a34cb74f022ec504cdbe4b8154eb6dad8886454c1fe2082b6c535aac3996"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0362a34cb74f022ec504cdbe4b8154eb6dad8886454c1fe2082b6c535aac3996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0362a34cb74f022ec504cdbe4b8154eb6dad8886454c1fe2082b6c535aac3996"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b6e663312986c5730bcfa4c358844b6985be4ea84ceabbd86bd44d044f499ce"
    sha256 cellar: :any,                 x86_64_linux:      "83240c9914bf25a51318d21ddcae981b62f25125d51959b84fcdebacd77d4769"
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
