class Resfetch < Formula
  desc "Fast and minimal alternative to neofetch"
  homepage "https://github.com/furtidev/resfetch"
  url "https://github.com/furtidev/resfetch/releases/download/1.0.2/resfetch-mac.tar.gz"
  sha256 "f24118a8f6f82152308a6c2af359fd631551fc8fbfe380e30d889ce12868bd5e"
  license "MIT"

  def install
    bin.install "resfetch"
  end
end
