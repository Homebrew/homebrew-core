require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v1.8.tar.gz"
  sha256 "c11842b3c0d74d865295c1a1e1ee89a9e3349de335b366944a0eb81ff3d4830f"

  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0737565c78b0a53f8d31db5e90194873594f70c2e27e10430fd583340739818" => :el_capitan
    sha256 "3ba1c67270a04f1c7810fcd8867b0a2be2f21f3e92ab7ac32f3cbf4ae670a326" => :yosemite
    sha256 "8695501f5a611b43f6cfde2be3087bd2093970675b2f116e0e6cc800f96ebcd3" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "fbb6674a7495706ad1ba2d7cca18ca9d804ccdca"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git", :revision => "91ab96ae987aef3e74ab78b3aaf026109d206148"
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
