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

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
        :revision => "ffdcd19858d03d5ebabba5bead2b5dfb18b2c73f"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "1efa31f08b9333f1bd4882d61f9d668a70cd902e"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "87d4004f2ab62d0d255e0a38f1680aa534549fe3"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/skratchdot/open-golang" do
    url "https://github.com/skratchdot/open-golang.git",
        :revision => "75fb7ed4208cf72d323d7d02fd1a5964a7a9073c"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
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
