require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.0.tar.gz"
  sha256 "85430661208fdcb57575017d2c6131d5720964a30c5a02ca9688b8fd56def81e"

  bottle do
    cellar :any_skip_relocation
    sha256 "38fb183bec1966bd1c1d7529a23afe5e618ec00ad990d349f3235e3e5663ffae" => :el_capitan
    sha256 "1c5db5b97a607dbdcc93d9242ee4656130ee2c9362974c0f5b5405d674f3a073" => :yosemite
    sha256 "c4fc8d42a8dfe26b70974e55ca78ab3d55189a10e463e3799eba8988c26a8b76" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
      :revision => "6d00f93158acefc3a0f605c171d1baa80ba86b73"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "c31a7975863e7810c92e2e288a9ab074f9a88f29"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
      :revision => "9aae6aaa22315390f03959adca2c4d395b02fcef"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
      :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
      :revision => "3dac7b4f76f6e17fb39b768b89e3783d16e237fe"
  end

  go_resource "github.com/skratchdot/open-golang" do
    url "https://github.com/skratchdot/open-golang.git",
      :revision => "c8748311a7528d0ba7330d302adbc5a677ef9c9e"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/vektorlab/"
    ln_sf buildpath, buildpath/"src/github.com/vektorlab/slackcat"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-s -X main.version=#{version}", "-o", bin/"slackcat"
  end

  test do
    assert_match /slackcat version #{version}/, shell_output("#{bin}/slackcat -v")
  end
end
