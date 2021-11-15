class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.5.0.tar.gz"
  sha256 "ee56c49dbb50a0810257445e434edb99da01c968da0635403f31bd9677886871"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5929f9b74a52e6a798d9a6b572622c401cd046811535823b50b31160eb190e4f"
    sha256 cellar: :any,                 arm64_big_sur:  "5d525f7b54988d3d3ca552abc7cfec45f9c069f726db42a44af9ceb3be148ae4"
    sha256 cellar: :any,                 monterey:       "d647df0d16f1e2975b7dcc557824b7549005a8a9057e839b39aaf38e5b81c986"
    sha256 cellar: :any,                 big_sur:        "e1b17e0a7dd036cdc8075f6af8b19ae976bb28f24209f9ed387f43efa2e1448c"
    sha256 cellar: :any,                 catalina:       "c16266957db69346464e39967d41d5198f3550423d6aabfb62919975cf52ea19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26610d706c2bdb477747126731405918b207233b90b13797afc3dcfe1155b3bb"
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
