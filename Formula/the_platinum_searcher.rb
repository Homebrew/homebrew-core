require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.2.tar.gz"
  sha256 "db8cbe30381e7f0a6cdb4b8ab306194483df16197b268790b6d8cee3f8d32d05"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79002190d8283143148692fad9a214afac535328e076d9df7c4dc66adcf88fdd" => :el_capitan
    sha256 "250fa9e36850257cc68d5ab6bcca89caadf4dc4969f563c1c9f2859d8df015fa" => :yosemite
    sha256 "0fb5e2484f0ee1a5283b729742208ee85a1523186a03856dd985aef25d5a76f5" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "f0aeabca5a127c4078abb8c8d64298b147264b55"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
    :revision => "b9b882a3990882b05e02765f5df2cd3ad02874ee"
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

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
    :revision => "2da212063ce19aed90ee5bbb00ad1ad7393d7f48"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
    :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "da88cb54a2fe4ec041612bd04b321d6a79d3ea81"
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
