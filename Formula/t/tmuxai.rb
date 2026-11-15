class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "99dfaaaa0d475873fd9004355e48354c7d8c6e1c009d767e2eb4300d9cfdbe4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5749cbc97020da11ea6156bdc0a4edfd00d57b3b1522cdeb9b5bb23ced7eecf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5749cbc97020da11ea6156bdc0a4edfd00d57b3b1522cdeb9b5bb23ced7eecf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5749cbc97020da11ea6156bdc0a4edfd00d57b3b1522cdeb9b5bb23ced7eecf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5935cb341c884aedc80bb1216343b060b7d2ad31951b88e9332f78512a16c51d"
    sha256 cellar: :any,                 x86_64_linux:      "c3d9ae5be9ee446c42d5b12ae7aef430ab951357e9faac2f9ca89cd36687aaba"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
