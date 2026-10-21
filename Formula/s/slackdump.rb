class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "02d97ccbff847274c475c523cdb017c3fab7a3c69502ad09644b454090513a2b"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f302320611f542b33fcc01abcd1fd2cbee96380f80fd88d1648de727bdec3d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f302320611f542b33fcc01abcd1fd2cbee96380f80fd88d1648de727bdec3d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f302320611f542b33fcc01abcd1fd2cbee96380f80fd88d1648de727bdec3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0859fd0b3aba89f429472e7bcba7b3ee6a9b520cb79d69e6a87d794a79afddce"
    sha256 cellar: :any,                 x86_64_linux:      "0d50d3bcc9c7c0a37d246307563409d07a5802f60015e4667a33a79e087d8e90"
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
