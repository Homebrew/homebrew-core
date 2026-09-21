class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.4.5.tar.gz"
  sha256 "6c910bb508c0789e65082adc3f8d1930cbb9cb2c27054fbf5e91d2b4a4a0ada0"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a98f8f06fa2d1e7ed5279f889adae673212d3506021cc3a06efce6ed57effaf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a98f8f06fa2d1e7ed5279f889adae673212d3506021cc3a06efce6ed57effaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a98f8f06fa2d1e7ed5279f889adae673212d3506021cc3a06efce6ed57effaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2969e280557e7332b18e6052b067e925834170323d8304fcc161627e748ceb33"
    sha256 cellar: :any,                 x86_64_linux:      "dfa9c647009e1267211101a7c37503431bfa31a9592640568d789b5245a11c09"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
