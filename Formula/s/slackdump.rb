class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.5.5.tar.gz"
  sha256 "641147fa55f7462133891649046d187a23141b07aa1c7ab29798fc37d4b9329b"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d3a2ab57bdd4ec37aeaacafdf9beed938d0fac193e335235172cb6289608be0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d3a2ab57bdd4ec37aeaacafdf9beed938d0fac193e335235172cb6289608be0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d3a2ab57bdd4ec37aeaacafdf9beed938d0fac193e335235172cb6289608be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b335b6946165ea62ebaeb71d8a51e36a24a2ef091ed2d72b1a8cacbd93482557"
    sha256 cellar: :any,                 x86_64_linux:      "254c1302aaea6546695ba7bc73742983329c8315ef1bdf7fd787f2a4e457d709"
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
