class Trickle < Formula
  desc "600 baud pipe and terminal."
  homepage "https://github.com/sjmulder/trickle"
  url "https://github.com/sjmulder/trickle/archive/43f1659c66de1bd32492c5a6e85ed9b9e9593ca1.tar.gz"
  sha256 "3648a94208c7059c57e6728a76aea2b9c4d8a511562ed7181323b7861aa97408"

  def install
    system "make"
    bin.install "trickle"
    bin.install "tritty"
  end

  test do
    system "false"
  end
end
