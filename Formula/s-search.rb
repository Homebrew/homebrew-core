require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.9.tar.gz"
  sha256 "7dba775f7fdf6c8dc28ace8795e8f57c0b7dd6148f14fe4b17c5a4eb46b675ec"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f56664578fff8503c568e1b638c336726ecf8d9b03797011e057afdc0e48ec22" => :sierra
    sha256 "dbf57d132010f1e1b6d2d17227ff86d0822f050be0b88c1f7e58a932c7d6024f" => :el_capitan
    sha256 "2cb23811b41c65b20b0ea3d4c061491ad58d10265c9840eb8fbded46a4cc1eac" => :yosemite
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
