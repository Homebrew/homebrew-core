class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.1.tar.gz"
  sha256 "5367e1ad32c6f895a3b85b9cb8a61aa73f402f86156db074e06f5f0a39614d19"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9a013fef9bfc12b384cee438b7d6fed60eda90b5d047b2cd574661ae7ee6b73"
    sha256 cellar: :any_skip_relocation, big_sur:       "d23ba4edd9c5a4009eab83933837add4ed2623016d5380d32509ba2a88ade346"
    sha256 cellar: :any_skip_relocation, catalina:      "c2aeed6d82c38d56f4f1875db98543d06b225568c0c619d63ebac1885092b033"
    sha256 cellar: :any_skip_relocation, mojave:        "10da5931d1023b2c34b82c96bbd059edacf8986f7d47dcbc60097ecbf765e429"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
