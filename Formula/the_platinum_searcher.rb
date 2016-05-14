require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.1.tar.gz"
  sha256 "627e01d6c80ea4c6e1406bb8a498640b0fd5ac9eef37c53e132c868c7f261c96"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79002190d8283143148692fad9a214afac535328e076d9df7c4dc66adcf88fdd" => :el_capitan
    sha256 "250fa9e36850257cc68d5ab6bcca89caadf4dc4969f563c1c9f2859d8df015fa" => :yosemite
    sha256 "0fb5e2484f0ee1a5283b729742208ee85a1523186a03856dd985aef25d5a76f5" => :mavericks
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
