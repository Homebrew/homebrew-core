require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.2.tar.gz"
  sha256 "efde5f9acdf072a833ccbbea5414c80dd5cd177664db41a3e61bf2eb384a8fe5"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cfc1e7ac3351cd84f8ce9aafef3512484dd26b71a26e624f9a550cf1b6b0685" => :sierra
    sha256 "16b2f127d5f0d9d3c1cd7ebebe85d8681ad244a2f666d857451b932f72d1b99a" => :el_capitan
    sha256 "544aaa7b4a26cfd750090bfb3dcb56ccbf7f1b4528074905f361774f62fd0d60" => :yosemite
    sha256 "1e3b19cc013cd9b6deed44b66b84968354cb49ac889672eb9ad34df8828b988c" => :mavericks
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
