class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.6.tar.gz"
  sha256 "e5c8f98f3048cccc3f8e49c0449435a839a18c7f12426643ac80731b63b829a9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d23ba4edd9c5a4009eab83933837add4ed2623016d5380d32509ba2a88ade346" => :big_sur
    sha256 "f9a013fef9bfc12b384cee438b7d6fed60eda90b5d047b2cd574661ae7ee6b73" => :arm64_big_sur
    sha256 "c2aeed6d82c38d56f4f1875db98543d06b225568c0c619d63ebac1885092b033" => :catalina
    sha256 "10da5931d1023b2c34b82c96bbd059edacf8986f7d47dcbc60097ecbf765e429" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
