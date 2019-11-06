class Slacknimate < Formula
  desc "Text animation for Slack messages"
  homepage "https://github.com/mroth/slacknimate"
  url "https://github.com/mroth/slacknimate/archive/v1.0.1.tar.gz"
  sha256 "ddac6002edd57a334ce828e2662264598ea7d471757747cffd85ffdfedbb044b"
  head "https://github.com/mroth/slacknimate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b21fd67e3132848ed429cc51ae5b620083351855384f9e1ff8a4d8612204fc65" => :catalina
    sha256 "2cae878e05448d6f0a7679319269e7c95fb2b879f4620b84a6b2b35d6ee739f4" => :mojave
    sha256 "6d93b3bbccb0190be8a2702d7fa3e587fa768110567e76b2a43f167381981707" => :high_sierra
    sha256 "f546be3bc842ef924e62c2dee561acdf114ee5206253d6e06a848eefd98dcafe" => :sierra
    sha256 "e07155d74980ed24bf07acce56c890a86668eb359aecae8dae6eb6973c38cfd8" => :el_capitan
    sha256 "f97ea26560c72c550780b81a124f8c69c8588c27e0f87eef65201676f2666672" => :yosemite
    sha256 "cf81016bb94d8d2369c98a529b575d3115a263139502294b528197e1ac293ae9" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    pkgpath = buildpath/"src/github.com/mroth"
    pkgpath.install Dir["*"]
    cd pkgpath do
      system "make"
      bin.install "bin/slacknimate"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/slacknimate", "--version"
    system "#{bin}/slacknimate", "--help"
  end
end
