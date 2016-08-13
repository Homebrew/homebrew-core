class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Despite the experimental tag the tools themselves are stable.
  # Please only update version when the tools have been modified/updated.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-experimental-0.0.20160722.tar.xz"
  sha256 "0dcda97b6bb4e962f731a863df9b4291c1c453b01f4faba78be4aaa13a594242"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "23d88bb47ff2aa10cdc9add6fc326b60f7f1a60b9a419249bca20b1843bbaf1f" => :el_capitan
    sha256 "6cee2c9452178aba10e5b118ed5c8d705467c5e25437cc6d587822a5d199a9c0" => :yosemite
    sha256 "81110c65982e178495f38d39f5d2f1f3e5a9ada37b22bc44260cdd92ffe806b6" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
