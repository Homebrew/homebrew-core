require "language/go"

class Wuzz < Formula
  desc "Interactive cli tool for HTTP inspection"
  homepage "https://github.com/asciimoo/wuzz"
  url "https://github.com/asciimoo/wuzz.git",
      :tag => "v0.4.0",
      :revision => "ef041bc912ea39081ddc5f8b3896ded90e8b053b"
  head "https://github.com/asciimoo/wuzz.git",
       :shallow => false

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "a368813c5e648fee92e5f6c30e3944ff9d5e8895"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "5df930a27be2502f99b292b7cc09ebad4d0891f4"
  end

  go_resource "github.com/jroimartin/gocui" do
    url "https://github.com/jroimartin/gocui.git",
        :revision => "4f518eddb04b8f73870836b6d1941e8aa3c06637"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
        :revision => "4ed959e0540971545eddb8c75514973d670cf739"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "75a6de4340e59be95f0884b9cebdda246e0fdf40"
  end

  go_resource "github.com/tidwall/gjson" do
    url "https://github.com/tidwall/gjson.git",
        :revision => "5a69e67cfd8f6f9b0044ed49f5079d0eeed28653"
  end

  go_resource "github.com/tidwall/match" do
    url "https://github.com/tidwall/match.git",
        :revision => "173748da739a410c5b0b813b956f89ff94730b4c"
  end

  go_resource "github.com/x86kernel/htmlcolor" do
    url "https://github.com/x86kernel/htmlcolor.git",
        :revision => "cf1d377eeb390aef407233fa4721c096bf789ac3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "0a9397675ba34b2845f758fe3cd68828369c6517"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/asciimoo"
    ln_s buildpath, "src/github.com/asciimoo/wuzz"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"wuzz"
  end

  test do
    system bin/"wuzz", "-h"
  end
end
