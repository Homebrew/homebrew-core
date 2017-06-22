require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.2.1.tar.gz"
  sha256 "c565563bb0383dbf7e970d9b6dd4a3fa15f0bc16f60ef9f9713bccd73aab21a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "beae45f6a51f1c9e48ba99329dbec63db4ab2f5f7babeadd72a6bf1e8a9ebebb" => :sierra
    sha256 "398a35d5cdf0117602636b97f8ed8f194dd5112451f3668b39adc2fa2cc4ba03" => :el_capitan
    sha256 "ef4cd950462ebeb9e25b57bc55f61272fe810592aee32013e46d86ed3a84f0d7" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "b26d9c308763d68093482582cea63d69be07a0f0"
  end

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
        :revision => "3b1fffcc45b37a2644a23eb7dc434d4d9f0987ba"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "8ba6f23b6e36d03666a14bd9421f5e3efcb59aca"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
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
