class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "3a460664e53edb6e25e01cb4546f887dfe16f2ef8168306a7d52afbd8edc3669"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac7e23b326ec76add3cd2691b3e205d14559450cd7036562017ad417d46756b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac7e23b326ec76add3cd2691b3e205d14559450cd7036562017ad417d46756b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aac7e23b326ec76add3cd2691b3e205d14559450cd7036562017ad417d46756b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe18965996abf7d873d3bd1d699d206ca7fe46024c1bef8f32bfc219fb33668"
    sha256 cellar: :any_skip_relocation, ventura:       "cbe18965996abf7d873d3bd1d699d206ca7fe46024c1bef8f32bfc219fb33668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300106207c35029f2ae67b14c321d0b0bc740076d6e08a3b1928108e99bec101"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end
