class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "dfa7142259bc7ac4a707aed6f2677c505de4803a874c45f746c26420e04cc5cd"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a72f3d0c2e08b4088c728685f7e7fafa89cacf342bd403a9c4e4288d24e02cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72f3d0c2e08b4088c728685f7e7fafa89cacf342bd403a9c4e4288d24e02cb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a72f3d0c2e08b4088c728685f7e7fafa89cacf342bd403a9c4e4288d24e02cb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e105f19ec3255efb90915aeac3fbf2c822f62d472f0269696dee5e97608f88e0"
    sha256 cellar: :any_skip_relocation, ventura:       "e105f19ec3255efb90915aeac3fbf2c822f62d472f0269696dee5e97608f88e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407789ff20c70bf0f8c693d52fdd202324253574854e4f7a0f7f6547e48516e4"
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
