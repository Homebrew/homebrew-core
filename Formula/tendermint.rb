class Tendermint < Formula
  desc "BFT replicated state machines in any programming language"
  homepage "https://tendermint.com/"
  url "https://s3-us-west-2.amazonaws.com/tendermint/binaries/tendermint/v0.12.1/tendermint_0.12.1_darwin_amd64.zip"
  version "0.12.1"
  sha256 "807b29cabc4e372aaee93347f617db8b88bf68c80cb40254c8cd0bd13110d51c"

  bottle :unneeded

  def install
    bin.install "tendermint"
  end

  test do
    tendermint_version_without_hash = shell_output("#{bin}/tendermint version").partition("-").first
    assert_match version.to_s, tendermint_version_without_hash
  end
end
