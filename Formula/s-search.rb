require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.7.tar.gz"
  sha256 "5ed6fff64b32f0955794679dd2ebf96af6c367dfb4fb5eea704ea83bb14f4b1b"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9273214fa31d1255028dc7b3246a42d78c975398f9bf3b5f96926c4ffa29c581" => :sierra
    sha256 "2fe361adb119d55e61b300ff1fd4727ba325566391521289a6ce7fc8106f531d" => :el_capitan
    sha256 "f30cbf7b1b101f312d126bd1cb6ac9d433b8978a90f7eae8fe413ea4aef31814" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/FiloSottile/gvt" do
    url "https://github.com/FiloSottile/gvt.git",
        :revision => "1f87bb350317842680fd7e0fdec64b4e14c79576"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/FiloSottile/gvt") { system "go", "install" }
    (buildpath/"src/github.com/zquestz").mkpath
    ln_s buildpath, "src/github.com/zquestz/s"
    system buildpath/"bin/gvt", "restore"
    system "go", "build", "-o", bin/"s"
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
