require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.4.tar.gz"
  sha256 "43c80b7d546bca51af47b3df8b79a2e5ce021042ea91d877e2feb33a7ca81305"

  bottle do
    cellar :any_skip_relocation
    sha256 "7725a6279d7b5d3ef84e2c475e9c5c0587b7dd0945309456446537dd4ca2df1c" => :high_sierra
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
        :revision => "307046097ee9f07094bb547c5d96d86d759054a6"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "5df930a27be2502f99b292b7cc09ebad4d0891f4"
  end

  go_resource "github.com/skratchdot/open-golang" do
    url "https://github.com/skratchdot/open-golang.git",
        :revision => "75fb7ed4208cf72d323d7d02fd1a5964a7a9073c"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "119bb6564841921ce6f1401e0f5d75317bdd9f4d"
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
