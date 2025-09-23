class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "4b57f005467b9ac1606b80408b9a85287366619bb84e058dcb5d259047ae8950"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16f626d589d5da7ecdd415db8905815ea1ce6cccc682854f0048b1d41a0faced"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16f626d589d5da7ecdd415db8905815ea1ce6cccc682854f0048b1d41a0faced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f626d589d5da7ecdd415db8905815ea1ce6cccc682854f0048b1d41a0faced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16f626d589d5da7ecdd415db8905815ea1ce6cccc682854f0048b1d41a0faced"
    sha256 cellar: :any_skip_relocation, sonoma:        "6536a8f3ff36d5f7f2ba61b1f332da63a9cfee977ecb46979f055abab1f4ac5e"
    sha256 cellar: :any_skip_relocation, ventura:       "6536a8f3ff36d5f7f2ba61b1f332da63a9cfee977ecb46979f055abab1f4ac5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6613bae1df484caf8f2fb51f508cf6eb38bfa99111c63db4cbae4209e5049878"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[
      -s -w
      -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
      -X #{mod}.Arch=#{Hardware::CPU.arch}
      -X #{mod}.Version=v#{version}
      -X #{mod}.Commit=#{tap.user}
      -X #{mod}.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yutu", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yutu version 2>&1")

    assert_match "failed to parse client secret", shell_output("#{bin}/yutu auth 2>&1", 1)
  end
end
