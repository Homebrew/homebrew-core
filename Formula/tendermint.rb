class Tendermint < Formula
  desc "⟁ Tendermint Core (BFT Consensus) in Go"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.0.tar.gz"
  sha256 "3a28fac4c5e610fc32763db1b717ec0a1e12d39262e321d6da223c3b0acfea7f"
  license "Apache-2.0"
  depends_on "go" => :build
  head "https://github.com/tendermint/tendermint.git"

  def install
    system "make", "tools"
    system "make", "build", "LDFLAGS=-X github.com/tendermint/tendermint/version.TMCoreSemVer=#{version}"
    bin.install "build/tendermint"
  end

  test do
    tendermint_version_without_hash = shell_output("#{bin}/tendermint version").partition("-").first
    assert_match version.to_s, tendermint_version_without_hash
  end
end
