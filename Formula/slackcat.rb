require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.3.tar.gz"
  sha256 "bea9d91f16d25fa91da24d0cbbebf333544d9e9a0b19549391ed7156199c6d77"

  bottle do
    cellar :any_skip_relocation
    sha256 "beae45f6a51f1c9e48ba99329dbec63db4ab2f5f7babeadd72a6bf1e8a9ebebb" => :sierra
    sha256 "398a35d5cdf0117602636b97f8ed8f194dd5112451f3668b39adc2fa2cc4ba03" => :el_capitan
    sha256 "ef4cd950462ebeb9e25b57bc55f61272fe810592aee32013e46d86ed3a84f0d7" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "a368813c5e648fee92e5f6c30e3944ff9d5e8895"
  end

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
        :revision => "b5a7526d62db4690f8a49a30c8ed46f90d0f29f7"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "8ba6f23b6e36d03666a14bd9421f5e3efcb59aca"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "67c513e5729f918f5e69786686770c27141a4490"
  end

  go_resource "github.com/skratchdot/open-golang" do
    url "https://github.com/skratchdot/open-golang.git",
        :revision => "75fb7ed4208cf72d323d7d02fd1a5964a7a9073c"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"slackcat",
           "-ldflags", "-X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
