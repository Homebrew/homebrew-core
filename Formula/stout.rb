class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "http://stout.is"
  url "https://github.com/EagerIO/Stout/archive/v1.2.2.tar.gz"
  sha256 "e04a44735c4c04ccce63e73d211d2a8c0232594b23c8dfc5c971c10d1aa72aaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1d9dfdf662db57af9a177ebffebb0aed586d7fb6e3c17df2eb9e7e70c7e4d7b" => :sierra
    sha256 "9020d9cfd6ca410fec81df29a31732c6c9025958e1247fb95f93e6c5942c389e" => :el_capitan
    sha256 "30cbc8417a496b515f41d743a883ad6821122b4ead8fe96b69d11d3cbd4a980b" => :yosemite
    sha256 "29c3f260aa2c7ac82a26304002fda6afe78ac9e7529b4b09f3fdaed031a8e764" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/eagerio"
    ln_s buildpath, buildpath/"src/github.com/eagerio/stout"
    system "go", "build", "-o", bin/"stout", "-v", "github.com/eagerio/stout/src"
  end

  test do
    system "#{bin}/stout"
  end
end
