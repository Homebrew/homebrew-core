class Tugboat < Formula
  desc "Build a working preview of a website in a git repository"
  homepage "https://tugboat.qa"
  url "https://dashboard2.tugboat.qa/cli/macos/tugboat.tar.gz"
  version "2.18.08.29.0"
  sha256 "25332979e6e367c79ec73f64f735c7945b1cb2c7012c1f7ab454bf692d2da8d8"

  bottle :unneeded

  def install
    bin.install "tugboat"
  end

  test do
    system "#{bin}/tugboat", "--help"
  end
end
