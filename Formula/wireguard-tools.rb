class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Despite the experimental tag the tools themselves are stable.
  # Please only update version when the tools have been modified/updated.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-experimental-0.0.20160722.tar.xz"
  sha256 "0dcda97b6bb4e962f731a863df9b4291c1c453b01f4faba78be4aaa13a594242"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  def install
    system "make", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
