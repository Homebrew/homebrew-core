class Romecli < Formula
  desc "CLI tool for Rome Server written in Swift"
  homepage "https://github.com/146BC/RomeCLI"
  url "https://github.com/146BC/RomeCLI/archive/0.2.0.tar.gz"
  sha256 "906ce9a4330ebd37030df8b41b05a12a04fd4fb65894e3d9cd5e983db5de4613"

  depends_on :xcode => ["7.3", :build]
  depends_on "carthage"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/romecli", "-h"
  end
end
