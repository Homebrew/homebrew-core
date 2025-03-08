class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "4357df862912b890bb53826bc0c4c3dd61daadabec1fde56b88ad7a2ac31de43"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1831b31d64f92c1d70d2da124b8db314ceb2383f725ab80f2832d71e8e2cf83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1831b31d64f92c1d70d2da124b8db314ceb2383f725ab80f2832d71e8e2cf83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1831b31d64f92c1d70d2da124b8db314ceb2383f725ab80f2832d71e8e2cf83"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c06ad2540671534e17898d36d544939c0dc064252b46f5f17d95dbc9eb63115"
    sha256 cellar: :any_skip_relocation, ventura:       "4c06ad2540671534e17898d36d544939c0dc064252b46f5f17d95dbc9eb63115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204e95e24077a4eb4d3770aa66da41e5e8b9a29f696a957c0bf530ebe7e4fd2f"
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
