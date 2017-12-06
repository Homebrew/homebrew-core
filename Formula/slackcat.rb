require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.4.tar.gz"
  sha256 "43c80b7d546bca51af47b3df8b79a2e5ce021042ea91d877e2feb33a7ca81305"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1bcaa0c2b10cb857978689be04d2a75865ea353259a5531a3da124fdf239eac" => :high_sierra
    sha256 "ba66b3b7c0d0376edf14e8b951026bd79b8d2f52cd8d3826ce4a1fc3b11d7004" => :sierra
    sha256 "b97794811a471a2cd1cb0ef9cd0045b2e2b68502c7c979239eda0b1ec56c9db3" => :el_capitan
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
