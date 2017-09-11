class Zapp < Formula
  desc "Continuous Code Generation"
  homepage "https://zappjs.com"
  url "https://cdn.zappjs.com/apps/zapp-cli/v0.1.0/zapp-cli_mac_v0.1.0.tar.bz2"
  sha256 "66b99a8dfd3a6b728f2d41b1e548abbc63235656112225293333ec03df97ce28"

  def install
    bin.install "zapp"
  end

  test do
    assert_match "ZappJS CLI version 0.1.0", shell_output("#{bin}/zapp --version")
  end
end
