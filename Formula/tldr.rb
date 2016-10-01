class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr-pages.github.io"
  url "https://github.com/tldr-pages/tldr-cpp-client/archive/v1.3.0.tar.gz"
  sha256 "6210ece3f5d8f8e55b404e2f6c84be50bfdde9f0d194a271bce751a3ed6141be"
  head "https://github.com/tldr-pages/tldr-cpp-client.git"

  bottle do
    cellar :any
    sha256 "3e843db1b1f35c9fb0e3cdd47f2eacaaf0411a8158d3c13a8826cccb0692ce7d" => :sierra
    sha256 "3f98b7a5abcf565a4bce8c674b1f8d0ac5f79075a96f8695eab627a162b8154b" => :el_capitan
    sha256 "9124b5e08e84aaf28cefb7a13ca37c969eb42edb3801ad73c6cb0e9a9092bc49" => :yosemite
    sha256 "6087f487eb4de38affd318f610b95af55724624ea376ba0010e451f2bffc82bd" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
