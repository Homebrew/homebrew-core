class Rslsync < Formula
  desc "It is a proprietary file sharing system for the BitTorrent protocol"
  homepage "https://www.resilio.com/"
  url "https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz"
  version "2.6.3"
  sha256 "9f6adeaea9a6bdbdf232bc585929816aeeeb3bd654252cabd99f1edb753b9384"

  def install
    bin.install "rslsync"
  end

  test do
    system "#{bin}/rslsync"
  end
end
