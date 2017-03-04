class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.0.1.tar.gz"
  sha256 "e151bf4e9f3fa133f801d7d5843ad5d3ada4cd44ec5ea9e98b77ccdea4587918"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system "#{bin}/shellshare", "-v"
  end
end
