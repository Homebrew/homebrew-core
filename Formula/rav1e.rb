class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.3.2.tar.gz"
  sha256 "e61fdce698ac25f19e25543efea076891296a74f53e3f8480665563ae2d5ff60"

  bottle do
    cellar :any
    sha256 "d1ce660afb9506d0543330bf5257171458aac6801fd5c4c56af379767cde38e7" => :catalina
    sha256 "f90aafd98174b4a5041ae9bd57acda090fe7b95275cd14158e167cfe401ed15a" => :mojave
    sha256 "21c0c59a4d32db38e3e7251cd90b54f0b1db2c7e9a7c7f1ab3b79b40277b703e" => :high_sierra
  end

  depends_on "cargo-c" => :build
  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
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
