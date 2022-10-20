class Selecta < Formula
  desc "Fuzzy text selector for files and anything else you need to select"
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/v0.0.7.tar.gz"
  sha256 "00d1bdabb44b93f90018438f8ffc0780f96893b809b52956abb9485f509d03d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c418f7d144207312dddff58fbffadb5d602d681c2704e73f65d9489ba5ff47a9"
  end

  def install
    bin.install "selecta"
  end

  test do
    system "#{bin}/selecta", "--version"
  end
end
