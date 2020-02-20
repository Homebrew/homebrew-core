class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.3.1.tar.gz"
  sha256 "581b50e1e550835b65dd20f3c851cf2dae93eac0ee016caadfaa5faef8eee6f0"

  bottle do
    cellar :any
    sha256 "063f54a70d80641a439b1e123a2a9f6d3b6f2a79fb54277be445bae5c6e64db5" => :catalina
    sha256 "86c960c361f5d99f70541b804730ab2440681c3f1d04f8d206b4f650f07d42cb" => :mojave
    sha256 "ef08d4a319dbdda565ee4489a1fe1d8c94ff9773f17b596e9246b99522aa62f2" => :high_sierra
  end

  depends_on "cargo-c" => :build
  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("bus_qcif_15fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_15fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
