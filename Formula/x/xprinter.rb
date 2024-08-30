# frozen_string_literal: true

class Xprinter < Formula
  desc "Driver of xprinter"
  homepage "https://galaxycal.github.io/homebrew-xprinter/"
  url "https://github.com/GalaxyCal/homebrew-xprinter/releases/download/v1.0.0/xprinter-1.0.0.tar.xz"
  sha256 "2bacdf67ca39448f2cf78a79f9a58c3ba0c070dd111fb90c4496c28d8572ff95"
  version "1.0.0"

  def install
    bin.install "xprinter"
    bin.install "xprinter-server"
  end

  test do
    system "#{bin}/xprinter", "--version"
  end
end
