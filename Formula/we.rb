class We < Formula
  desc "WeDeploy command-line tool for creating, managing, and scaling applications"
  homepage "https://wedeploy.com/"
  url "https://bin.equinox.io/c/8WGbGy94JXa/cli-stable-darwin-amd64.tgz"
  version "1.1.10"
  sha256 "185be387fcff798cb075ee049d68cf091ce8191ea963b65b9ded5332d86505de"

  bottle :unneeded

  def install
    bin.install "we"
  end

  test do
    system "#{bin}/we"
  end
end
