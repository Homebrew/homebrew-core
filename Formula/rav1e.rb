class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.3.3.tar.gz"
  sha256 "a091f3387055e472b6e028aa013cf0f37fb5acce9f4db2605d929bbffb448d01"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "b8c0b0614f67553f771f709f0849479a9aa86883d5b7c5d59df60fc6544a9a11" => :catalina
    sha256 "fec7ae58dbdc997241a5337381d6523388e8e09b19e5e8e3db509aa5052df2fa" => :mojave
    sha256 "fe29e3982e41708784f0597c2f4a15ea217843a18b95f88e83f5d0f76a039ab6" => :high_sierra
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
