class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.39.0.tar.gz"
  sha256 "4e79e009d7d38cc25233aa0ab17e1e435ffd5a634a1c14d15fc7aa4d0c4c90bd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b929b0e0237422ef9a31b272755c9828a5e9654f80706af015a33eb4b8582d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b929b0e0237422ef9a31b272755c9828a5e9654f80706af015a33eb4b8582d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b929b0e0237422ef9a31b272755c9828a5e9654f80706af015a33eb4b8582d58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b929b0e0237422ef9a31b272755c9828a5e9654f80706af015a33eb4b8582d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a35527f8992cdd4105b86d06e4163141b7a1e5e046762930bda930429c43f87"
    sha256 cellar: :any_skip_relocation, ventura:       "5a35527f8992cdd4105b86d06e4163141b7a1e5e046762930bda930429c43f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc74d98613e0d498c89c0e4ec674f0b1d66d40bf4ead62cf66923c9c258f297"
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
