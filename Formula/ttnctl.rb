class Ttnctl < Formula
  desc "The Things Network Control Utility"
  homepage "https://www.thethingsnetwork.org/docs/network/cli/"
  url "https://ttnreleases.blob.core.windows.net/release/v2.5.3/ttnctl-darwin-amd64.tar.gz"
  version "2.5.3"
  sha256 "c913ff2db1e49d30539057a707d31443bd95d484d3433545cac5b09b7a915f75"

  def install
    bin.install "ttnctl-darwin-amd64"
    mv "#{bin}/ttnctl-darwin-amd64", "#{bin}/ttnctl"
  end

  test do
    system "#{bin}/ttnctl", "version"
  end
end
