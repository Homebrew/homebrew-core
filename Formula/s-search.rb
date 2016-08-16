require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.6.tar.gz"
  sha256 "259dd724e7c76019c25d0eed5c5d01f69368508d3967cdb84c995d18476185ba"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d3af52f97d3a7d5a6de84862871f3ed3d8daf17b0724a74d18eb36e70d56672" => :el_capitan
    sha256 "c4dadd872915c59f94fb6d92b3007dc8ea18f715335acb528483c6ead54c6732" => :yosemite
    sha256 "0e80bd4d0f743206a2920daf59fe58070312bf421805ab281caac672af22c54e" => :mavericks
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
