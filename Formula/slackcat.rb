class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.2.tar.gz"
  sha256 "562858968aeb67aedb32a6048512d6433bcc41fd3c17ae5d657f2f2d2e415cf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "573b9dc9cab32f434893b448785d50e3d91e6db1ea9a6366b3a36717ce5b2bc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1d26c211de44c839088eb8e20ad1b52d80582b7f4c51f72dec6a010550c6887"
    sha256 cellar: :any_skip_relocation, catalina:      "eefe126445524877fc420ca4b0b02f81279f80f7fc96d9eb35950fc69c2ca1db"
    sha256 cellar: :any_skip_relocation, mojave:        "01c1b98eb844950c4df1140ea7b4ed1e0e53ee742bb8e1d7675435350dbe056f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
