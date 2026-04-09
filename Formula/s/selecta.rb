class Selecta < Formula
  desc "Fuzzy text selector for files and anything else you need to select"
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "737aae1677fdec1781408252acbb87eb615ad3de6ad623d76c5853e54df65347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fb1dc1bfe59101569e6aea3522d36cf406a2c9b2b86464fce089cc36356b75f"
  end

  uses_from_macos "ruby"

  def install
    bin.install "selecta"
  end

  test do
    system bin/"selecta", "--version"
  end
end
