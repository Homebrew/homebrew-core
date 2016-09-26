require "language/go"

class Wellington < Formula
  desc "Project-focused tool to manage Sass and spriting"
  homepage "https://getwt.io/"
  url "https://github.com/wellington/wellington/archive/v1.0.3.tar.gz"
  sha256 "d3d49a53bc6d206a751585d4cf14fc895d02ea21cb1ef3c508e032db192d3001"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97b49f62ebd3d40d60fd849d9c8488e168990ac7ce125b1905a1dc3f931b9f98" => :sierra
    sha256 "98ad5ec71b20c442f9b702ffefcf7ea07bc4dc3912b4f67bc754989acd6caf41" => :el_capitan
    sha256 "951a21d24cd741d2eeb34287dfbc31590070c6e1fbc3330abc326abbe0d35604" => :yosemite
  end

  needs :cxx11

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        :revision => "f09c4662a0bd6bd8943ac7b4931e185df9471da4"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/wellington/wellington"
    dir.install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd dir do
      system "go", "build", "-ldflags",
             "-X github.com/wellington/wellington/version.Version=#{version}",
             "-o", bin/"wt", "wt/main.go"
      prefix.install_metafiles
    end
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<-EOS.undent
      /* line 1, stdin */
      div p {
        color: red; }
    EOS
    assert_equal expected, pipe_output("#{bin}/wt --comment", s, 0)
  end
end
