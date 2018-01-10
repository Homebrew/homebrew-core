class Shunit2 < Formula
  desc "xUnit unit testing framework for Bourne-based shell scripts"
  homepage "https://github.com/kward/shunit2"
  url "https://github.com/kward/shunit2/archive/v2.1.7.tar.gz"
  sha256 "41a103aa984bfdeea3fec426edb0b3dda19153a5ce448d4b4bbe52a85c4d7fee"

  bottle :unneeded

  def install
    bin.install "shunit2"
  end

  test do
    system bin/"shunit2"
  end
end
