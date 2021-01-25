class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.4.0.tar.gz"
  sha256 "c3ea1a2275f09c8a8964084c094d81f01c07fb405930633164ba69d0613a9003"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "7c5efa85248038652cc305152a7f20169207fff67f415d77dfd60ebd5c32475d" => :big_sur
    sha256 "bb5df331b2c407b3a948348229a2a2e98aa5f80cc2bc507d1284464c7ce778e3" => :arm64_big_sur
    sha256 "3931f7d8519ad401b6b59de5b4a0973f6b38125f1f5dc080db9975a56852f657" => :catalina
    sha256 "7661bd71b1d63e58f61147d3dd04bed99e99aa0ffccc7d48cc5a6dabb39a5911" => :mojave
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
