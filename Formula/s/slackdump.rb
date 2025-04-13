class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.0.10.tar.gz"
  sha256 "fd3a560de14d224e497bc9360d1665d17144b3a0ce9fffa59a69fbf840e9e759"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9334f94e4648e8ba0e061675872d85d52c1276966df478c794cf61672f2e691e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9334f94e4648e8ba0e061675872d85d52c1276966df478c794cf61672f2e691e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9334f94e4648e8ba0e061675872d85d52c1276966df478c794cf61672f2e691e"
    sha256 cellar: :any_skip_relocation, sonoma:        "73aa36d87aea85a9454838dae43cdc360c6489529cc7d84d6e6c966f27ed5e65"
    sha256 cellar: :any_skip_relocation, ventura:       "73aa36d87aea85a9454838dae43cdc360c6489529cc7d84d6e6c966f27ed5e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d21878f688c3a8090be8a36596e36b684e93ca565727ee9b2c52743fede3fed9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end
