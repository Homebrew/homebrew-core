require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v1.9.tar.gz"
  sha256 "c6c9e3b710692574714bb697ba4f8486da46ba2ff77f6501be8befc32c15c269"

  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c34b24081e7db7b67c07981cfa7f3c2dc205950fee0f65aaee15609e97ed74c" => :el_capitan
    sha256 "bf0370c3b3dc0d68030ee43b83bf4c7bc5e5fe33f0912c64d0312436d5428bc2" => :yosemite
    sha256 "d3ecc735a5188d2861eeb8a630cb0323a1e0b5a32bb38d23446101bfe4e3a244" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git",
        :revision => "fbb6674a7495706ad1ba2d7cca18ca9d804ccdca"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
        :revision => "91ab96ae987aef3e74ab78b3aaf026109d206148"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/JamesClonk/"
    ln_sf buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "go", "build", "-o", "vultr", "."
    bin.install "vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
