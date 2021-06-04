class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.2.tar.gz"
  sha256 "562858968aeb67aedb32a6048512d6433bcc41fd3c17ae5d657f2f2d2e415cf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4afbc9b42ef6eff3b63598a4c241d16ab5673912139b39e259b521d8ff40fd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffd89b1f8ec05ad9258fbed8b8e1a2f11345414de7d160cbf11250887a4b037b"
    sha256 cellar: :any_skip_relocation, catalina:      "ca236771d46645d91e47f6b907fd2171822f6f7d0ca79e5c086366c73b5e57c7"
    sha256 cellar: :any_skip_relocation, mojave:        "874dfe7ec201371aa7f8b5e011db03cf573c63c893ecb7f851eabd839c144a98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
