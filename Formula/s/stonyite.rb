class Stonyite < Formula
  desc "A eng-kor dictionary for the terminal users"
  homepage "https://github.com/5-23/stonyite"
  url "https://github.com/5-23/stonyite/releases/download/v0.1.1/stonyite.tar.gz"
  sha256 "e78038574d5f6cd3f0d4ae73331df3852915dd71ba0ef34f4a7e79f6ea2cb249"
  version "0.1.1"

  def install
    bin.install "stonyite"
  end
end
