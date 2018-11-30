class Uno < Formula
  desc "Uniq + edit-distance based fuzzy matching"
  homepage "https://unomaly.com"
  url "https://s3-eu-west-1.amazonaws.com/unomaly/releases/uno_mac/uno.zip"
  version "0.1.0"
  sha256 "1e70bab9803e90307f23ab6fe990997c04fe792a6d1efe8d97e4b217ecbd3dc5"

  def install
    bin.install "uno"
  end

  test do
    assert_match "Hello", shell_output("echo Hello | #{bin}/uno")
  end
end
