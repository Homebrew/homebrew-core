class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.5.1.tar.gz"
  sha256 "7b3060e8305e47f10b79f3a3b3b6adc3a56d7a58b2cb14e86951cc28e1b089fd"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d48bd483e2d92e70f329a6adf29c93d67af0d6510c3d7163e49000067be4a26"
    sha256 cellar: :any,                 arm64_big_sur:  "f87657ce277bf69054832d9e628edd18a4f4ea39df298a2e81db0a85f5da0e56"
    sha256 cellar: :any,                 monterey:       "4cc9765faec8aeca62be987bbcd113fd6227f4ed027dcc64e9b197ec52663c23"
    sha256 cellar: :any,                 big_sur:        "4464e4eec498522d840e1ef3b919bba86ca7a2eb04d12a9b939005382437b201"
    sha256 cellar: :any,                 catalina:       "9ce2a8b3dff9374e3a9603fc51e5b26bee38450ad91df06681fcb02f2844f5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3d6e1b0f3b5e7c1b2a8936eeeb59a24257fa0c71f6c8f70aaf647b4c694cfc"
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
