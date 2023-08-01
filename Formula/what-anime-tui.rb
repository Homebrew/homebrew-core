class WhatAnimeTui < Formula
  desc "Another way to find the anime scene using your terminal"
  homepage "https://github.com/mandriota/what-anime-tui"
  url "https://github.com/mandriota/what-anime-tui/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "2c1ac8e7d98fde022158a0bb6eb7c87f63531ebe00241a6e5b4dacaa4512b206"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go build -ldflags=\"-s -w\""
    bin.install "what-anime-tui"
  end

  test do
    system "ls", "#{bin}/what-anime-tui"
  end
end
