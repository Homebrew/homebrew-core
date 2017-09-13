require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.3.tar.gz"
  sha256 "bea9d91f16d25fa91da24d0cbbebf333544d9e9a0b19549391ed7156199c6d77"

  bottle do
    cellar :any_skip_relocation
    sha256 "67b5641e49b8190f8fd70c8863561ba10f71648d61d600658299ae617930da1d" => :sierra
    sha256 "5bcb1b8a7891afee3e5b663685222c95dd500437797d5e8ae81d6f5f2e55a621" => :el_capitan
    sha256 "9fd2b8c5c1210ea9133341108eb6a7a148bef9443ac2f85d3488c200f6f607c9" => :yosemite
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
