require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.11.tar.gz"
  sha256 "37e585a4bc66bc4b41b17d94099e6a1e696d5429e916e3e65c5a961540183a27"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e83c81203408155ccd9a9c26e4569996afe83d2ddfdb9d3e82cfa9e98662755" => :sierra
    sha256 "d386a3c79b5e9124db394daf5597a20704d6d3d63322504d4a62bbd051fc91ed" => :el_capitan
    sha256 "ef7633627980f70a86d0620e478c91e5f7f8b20f635a91a16b39065d0bba64d0" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/FiloSottile/gvt" do
    url "https://github.com/FiloSottile/gvt.git",
        :revision => "50d83ea21cb0405e81efd284951e111b3a68d701"
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
