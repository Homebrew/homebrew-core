class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.44.1.tar.gz"
  sha256 "c9178d944a13159df2c16ebe79be14e4e2cfa48877a5d5e4a15986d3f6e5ad3a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82cade9d4843ec59d4b555a556c2e63e78e05c018d08fc994aa419e7615f515a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82cade9d4843ec59d4b555a556c2e63e78e05c018d08fc994aa419e7615f515a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82cade9d4843ec59d4b555a556c2e63e78e05c018d08fc994aa419e7615f515a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9a93dd13cdeb5908e3a1914bc880864b9053af3d3e10a3f13f8d64086ff40e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ae886d5d7185a3463c41b81fc052fa7d0eba43dc9884aec5e0d6991120abe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "055b731349c844eca2938ff8e646f464bd852af654f68bcb1c7ca5f42ac0d7ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

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
