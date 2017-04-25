require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.2.1.tar.gz"
  sha256 "c565563bb0383dbf7e970d9b6dd4a3fa15f0bc16f60ef9f9713bccd73aab21a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a22f997fbe87df2f5dbeb737bf0e23b198c1085d03af604c22e1300ca2dfeb1" => :sierra
    sha256 "639ffb80f71174af2e4c05ab7b7f1c91baf787c507016b37dbb9190dabaa366a" => :el_capitan
    sha256 "ce8b07ccb48e8dc8ca522a9da8aa4be52e731072179e5599f440754565442a4e" => :yosemite
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
