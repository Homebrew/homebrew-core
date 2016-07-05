require "language/go"

class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.2.0.tar.gz"
  sha256 "13882bbbbcb86e05d6729f5bab2507de3aeabc1b4b4b34008480ee7549212c86"

  bottle do
    cellar :any_skip_relocation
    sha256 "6391f9b576bbbdcc136d92e16f69090589fbb6da73c23bb4ca160670f776afa1" => :el_capitan
    sha256 "f90e4215f3eb542d81a1f22885e99a24fb2f9cb98febba8060b52fc0edbcdeac" => :yosemite
    sha256 "6660423f7b92d5843a28341fd7eeae4ce965fd38bb8c8f38495d52e8d2f18f20" => :mavericks
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
