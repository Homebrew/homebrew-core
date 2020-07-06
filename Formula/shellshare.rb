class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.0.4.tar.gz"
  sha256 "55bfb1521f312b9b9b3e7bc10c9ab8e0c198278e6372187556a8d310ee6b602a"
  license "Apache-2.0"

  bottle :unneeded

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system "#{bin}/shellshare", "-v"
  end
end
