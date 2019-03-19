class Redo < Formula
  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.41.tar.gz"
  sha256 "b7c6411185c58d05bafd0dabeb1f45873bc9bb87f7749705964792fa3fb9fedc"

  bottle do
    cellar :any_skip_relocation
    sha256 "5471cdd4085c91f930069c8a8a315a3847739a79703758c104013ffe97a7618a" => :mojave
    sha256 "b205f9ef95a30c922d62e0deba1be29a0bbbd95d160341261711edaf49e92b82" => :high_sierra
    sha256 "630ac52a05e6b4586f1f78219bc9bce9d17cd67ab1b4acccb3d62256c2839bce" => :sierra
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
