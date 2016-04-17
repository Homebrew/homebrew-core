require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.1.tar.gz"
  sha256 "627e01d6c80ea4c6e1406bb8a498640b0fd5ac9eef37c53e132c868c7f261c96"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d3979c24e1dc16b2facf14031b4cb72f1306a783470fb296e9a59b19222e91a" => :el_capitan
    sha256 "3abdcc4eae1a77c137947974c1ee4e1e1d34d80022729fe45978a1183412a492" => :yosemite
    sha256 "2ee014d17b5017224105c472a2397916382918f6a31d93d1f88d811ba3ee8870" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "6b9493b3cb60367edd942144879646604089e3f7"
  end

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
        :revision => "2da212063ce19aed90ee5bbb00ad1ad7393d7f48"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "691ac7d4ac14053de3cbe16e07b79246300db97d"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "02704b6b714738b763ba478766eb55a4b4851cd4"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end

  go_resource "github.com/monochromegane/conflag" do
    url "https://github.com/monochromegane/conflag.git",
        :revision => "6d68c9aa4183844ddc1655481798fe4d90d483e9"
  end

  go_resource "github.com/monochromegane/go-gitignore" do
    url "https://github.com/monochromegane/go-gitignore.git",
        :revision => "38717d0a108ca0e5af632cd6845ca77d45b50729"
  end

  go_resource "github.com/monochromegane/go-home" do
    url "https://github.com/monochromegane/go-home.git",
        :revision => "25d9dda593924a11ea52e4ffbc8abdb0dbe96401"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    mkdir_p buildpath/"src/github.com/monochromegane"
    ln_s buildpath, buildpath/"src/github.com/monochromegane/the_platinum_searcher"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"pt", "cmd/pt/main.go"
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
