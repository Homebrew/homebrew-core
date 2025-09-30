class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "c9a6ba14f836ef38f3c465379f35420bc299a4fdae28228ee0c1d73021ca677f"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69b9bf08f7c1a7e957a9aaa282315fc1a977104fda68205fe907f413f388dd1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66d617da348020c858881f0473cba70903c86f1715f03f7876887c3b22e8662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66d617da348020c858881f0473cba70903c86f1715f03f7876887c3b22e8662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d66d617da348020c858881f0473cba70903c86f1715f03f7876887c3b22e8662"
    sha256 cellar: :any_skip_relocation, sonoma:        "2636bce14d35eaedea5ff2e6837e4cf01f180a9df5544e7b36265521286532c5"
    sha256 cellar: :any_skip_relocation, ventura:       "2636bce14d35eaedea5ff2e6837e4cf01f180a9df5544e7b36265521286532c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05a46804c4bdde6d9f2d516156c61ccfae814bc50650dd51ccce6b47e712dd7"
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
