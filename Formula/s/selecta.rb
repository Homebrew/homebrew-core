class Selecta < Formula
  desc "Fuzzy text selector for files and anything else you need to select"
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "00d1bdabb44b93f90018438f8ffc0780f96893b809b52956abb9485f509d03d2"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ec55655e3c404bba347f242a7b24e7504b181fd2f364a85dad9e4c770231a79d"
  end

  uses_from_macos "ruby"

  def install
    bin.install "selecta"
  end

  test do
    system bin/"selecta", "--version"
  end
end
