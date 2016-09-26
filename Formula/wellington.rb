require "language/go"

class Wellington < Formula
  desc "Project-focused tool to manage Sass and spriting"
  homepage "https://getwt.io/"
  url "https://github.com/wellington/wellington/archive/v1.0.3.tar.gz"
  sha256 "d3d49a53bc6d206a751585d4cf14fc895d02ea21cb1ef3c508e032db192d3001"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3656e211a96b653dbb5d32a8e4f51a6b68bd3ee95019aad8cd0f4d512352da38" => :el_capitan
    sha256 "8fcca3d1cc4f4ae6f2821b4b215c58ab6c7d88178b5c4cffe7adc72e86da38c5" => :yosemite
    sha256 "2ef26afb326f22102249daee8c795fb467ce9716a2aae306efd23efc65020df3" => :mavericks
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
