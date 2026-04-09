class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "15b668420cb9d679f287207169be969a7afb559e2977b3b742f3cab46836dd4f"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b99034cab70d828783c4cb07561f8147e040ad86b782a61aa146b98f69c33ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b99034cab70d828783c4cb07561f8147e040ad86b782a61aa146b98f69c33ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b99034cab70d828783c4cb07561f8147e040ad86b782a61aa146b98f69c33ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f03746d5d05ae9cedc6fe8dd2612a46f03db692b724db09b48e5708acd6a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50935592798910d9a259de898c8c8abb16d75dcbcda5a75f48686cff29f3789f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9378b6ff74592ca026322b699fb2ec7f53b6876f89c7b993127b3ec2aff185"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
