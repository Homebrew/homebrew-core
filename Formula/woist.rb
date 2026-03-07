class Woist < Formula
  desc "CLI tool to analyze IPs, domains and URLs with DNS, GeoIP, ASN and network analysis"
  homepage "https://github.com/Lemmy8495/woist"
  url "https://github.com/Lemmy8495/woist/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "a4e96cf4581fa2a1461b5391cea80d2cbc341741f677a4ad89c2aed3c94f73a6"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "woist"
  end

  test do
    system "#{bin}/woist", "--help"
  end
end
