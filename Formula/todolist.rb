require "language/go"

class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.3.0.tar.gz"
  sha256 "3ec300a8f900c6c75d21a7178df73778b7572b8936fe0b2a73317941d6e8fa04"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0ef9f95fa1d682b51f71b75dc46e705c7d7f862b6ed24d55e17a9573b6a5f7d" => :el_capitan
    sha256 "c79c6abc21121073283243176aabca2560558d654bd8caed2e6bd93666755a90" => :yosemite
    sha256 "15d3e8b5304156097d843c2f4aabeb1b79f03cd67a57243a4040acaf426fb63d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
    :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
    :revision => "9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
    :revision => "87d4004f2ab62d0d255e0a38f1680aa534549fe3"
  end

  go_resource "github.com/jinzhu/now" do
    url "https://github.com/jinzhu/now.git",
    :revision => "d9861969c7a7e84746d341c09020c2ef8a617f8f"
  end

  go_resource "github.com/julienschmidt/httprouter" do
    url "https://github.com/julienschmidt/httprouter.git",
    :revision => "77366a47451a56bb3ba682481eed85b64fea14e8"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/gammons/").mkpath
    ln_s buildpath, buildpath/"src/github.com/gammons/todolist"

    system "go", "build", "-o", bin/"todolist", "./src/github.com/gammons/todolist"
  end

  test do
    system bin/"todolist", "init"
    assert File.exist?(".todos.json")
    add_task = shell_output("#{bin}/todolist add learn the Tango")
    assert_match "Todo added", add_task
  end
end
