class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.4.1.tar.gz"
  sha256 "b0be59435a40e03b973ecc551ca7e632e03190b5a20f944818afa3c2ecf4852d"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e5dd3ae4c9492d6984dbc4f67a0b0fac23b4bd9294f6ba80a6621c94e841f70c"
    sha256 cellar: :any, big_sur:       "7c9ead158025ca4faa1236a5a14194dfc849ef5e199abf87e9d63cbef70b44ae"
    sha256 cellar: :any, catalina:      "360c7d268a838420b20b7c59cf7df38d37b50a3f5b75d02ea326f4a4de96b433"
    sha256 cellar: :any, mojave:        "a9d58a74c083653d4cdbde52224b8aecf01d30a60d9c11b8fc4cfc78b89e9ab3"
  end

  depends_on "cargo-c" => :build
  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
