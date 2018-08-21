class Redo < Formula
  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.11.tar.gz"
  sha256 "2d7743e1389b538e2bd06117779204058fc0fcc0e05fd5ae14791d7f3fc3bcfa"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "353eca6deb6d052176bc79982f151d1e7baa916c52844a021bfd4abcecbc36c7" => :mojave
    sha256 "73245e29a910908beebc16fb2b9ac64f7b6839b5656904a9abd96ec68796c86a" => :high_sierra
    sha256 "81834b6558862943db1789472cc50393dfece52dcc4b4d1720fd85c11a615217" => :sierra
    sha256 "ffb1132c1c7327971b89c6a6bfd7abe267f08c0790dc66816c09052c93a28ebb" => :el_capitan
    sha256 "70523de82822fa0cb289197dbbd228a6105781e80fd89dc1ea594637eccad6a1" => :yosemite
  end

  resource "docs" do
    url "https://github.com/apenwarr/redo.git", :branch => "man"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./redo", "install"
    rm share/"doc/redo/README.md" # lets not have two copies
    man1.install resource("docs")
  end

  test do
    system "#{bin}/redo", "--version"
  end
end
