class Zion < Formula
  desc "Provides E2EE gateway to create secure communication"
  homepage "https://nullby1e.github.io/zion/"
  url "https://github.com/a1eaiactaest/zion-formula/archive/0.0.2.tar.gz"
  sha256 "4e68d5c8dfa1d532736e4a29bfe17fac1a084d44a3714c90806bedc9452986b2"
  license "WTFPL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build
  depends_on "tor" => :build

  uses_from_macos "unzip" => :build

  def install
    system "./configure"
    bin.install "zion-gateway"
  end

  test do
    pipe_output("#{bin}/zion-gateway -h", 0)
  end
end
