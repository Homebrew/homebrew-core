class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "5bf7d3317315b288446f22b6f6b23f2b1a576578179c26ae435068bd8864a063"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8049a93217e75b6835d31ccf98289d8b317ae253c4ddf285300f1c96678e252b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8049a93217e75b6835d31ccf98289d8b317ae253c4ddf285300f1c96678e252b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8049a93217e75b6835d31ccf98289d8b317ae253c4ddf285300f1c96678e252b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f47a38da0b76e96f26e7ef968ffb929faaa2fefa1990c29a3b6921bf593156c"
    sha256 cellar: :any,                 x86_64_linux:      "5ece1f02cdaa9a25dcd433b8ad00427ab9703ce1f639cd868033107b96b30b42"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
