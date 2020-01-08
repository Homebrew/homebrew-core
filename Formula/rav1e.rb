class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.2.1.tar.gz"
  sha256 "6bb57bd744516aec2e11cb7076538694a44e5bf628d3d91a935dd8e3ee5a7ff6"

  bottle do
    cellar :any
    sha256 "c84e220a523e8d535a1b3b5313b6a0afd843f5ebc8c023d0bdadd04f1d6a51dd" => :catalina
    sha256 "a031e37a5b91a4f5524b030332c1104c617cc8dcd65c55ae3f2336fbec5b3542" => :mojave
    sha256 "ff04ff708d7a1719609d5e1f5474405eb465ca602cef7437c4fc7f35206ed96e" => :high_sierra
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
