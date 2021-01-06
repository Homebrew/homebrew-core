class TwitchCli < Formula
  desc "CLI for Twitch's devleoper offerings"
  homepage "https://github.com/twitchdev/twitch-cli"
  url "https://github.com/twitchdev/twitch-cli/archive/0.1.0.tar.gz"
  sha256 "a0aeaadf147f66d072bc6692b7c15141d4b4e2df065b3db6e14e3b2048864b53"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = "-X main.buildVersion=#{version}"
    system "go", "build", "-ldflags=#{ldflags}"
    bin.install "twitch-cli" => "twitch"
  end

  test do
    system "#{bin}/twitch", "version"
  end
end
