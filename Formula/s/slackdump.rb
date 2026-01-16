class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.11.tar.gz"
  sha256 "4c859384f7391ef5d0346b8684a32810d8dbbdb3367d71f581746ef3c44f1559"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0c027504734f97cd042b5306b6204f3bea0ab11da7822aea2326e2b2db149a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0c027504734f97cd042b5306b6204f3bea0ab11da7822aea2326e2b2db149a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0c027504734f97cd042b5306b6204f3bea0ab11da7822aea2326e2b2db149a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee6f4fff56774d9d347fee1c3c58e42eecb34025db05111287bdfbdd956df439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9655dab116522d5de352a4f642574266f44ee37d753282fae2a19b2317deafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b542602949342e1aebdf21fc7d04560220cb2ca3bc45f30a4424144d8172006"
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
