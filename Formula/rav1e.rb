class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.2.0.tar.gz"
  sha256 "c0fa8ee189f506c1a2dfd4b497ebb4e52739e850e1ecce7c02e6bc1073e63d66"

  bottle do
    cellar :any
    sha256 "ff6c986f43158d80a3e05c87b9b9dfd689f3455a985b3475c6c5f2a31e18ba06" => :catalina
    sha256 "468d4e183aa3d28b8cf41607795cb9f457e736ca343c9f3c08c93ed09f6b8159" => :mojave
    sha256 "5d315f9e72e37a21a18a49c4333e1d948005eb8f383a0fe9ecdb2602ee519a49" => :high_sierra
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
