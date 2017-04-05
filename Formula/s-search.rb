require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.9.tar.gz"
  sha256 "7dba775f7fdf6c8dc28ace8795e8f57c0b7dd6148f14fe4b17c5a4eb46b675ec"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9138b42eade3ecec0ac3fd2a0e8f58407683df6fe6383fddc6425ecb626dca9b" => :sierra
    sha256 "f87020282baa3808aa784b5a2354514db5f71fee1cc0812430e581c88bafb935" => :el_capitan
    sha256 "2104366234c518547d528d090782d987ddea18a5bb0f777a8589661df764aad5" => :yosemite
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
