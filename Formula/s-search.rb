require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.6.tar.gz"
  sha256 "259dd724e7c76019c25d0eed5c5d01f69368508d3967cdb84c995d18476185ba"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "658e3935d2c6e914915658173937f97e394d1d98ca6dd250fa90c44ed18a2c08" => :el_capitan
    sha256 "e63dbaa27b6130a90c095a80020ff92eb4775e9e3bc6b34a6df784fb4eee6a95" => :yosemite
    sha256 "9618a7a43b833541e8293c8234c672a7c8753627adbf0d5bed01629f096185bf" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/FiloSottile/gvt" do
    url "https://github.com/FiloSottile/gvt.git",
        :revision => "945672cd8cb7d1fe502c627952ebf6fcb1f883f1"
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
