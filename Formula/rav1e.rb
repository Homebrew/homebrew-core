class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.2.0.tar.gz"
  sha256 "c0fa8ee189f506c1a2dfd4b497ebb4e52739e850e1ecce7c02e6bc1073e63d66"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a7fe6d524b3a1acd21318f391772ba3e6a166b3766b93a53e3d16f62ea65c22" => :catalina
    sha256 "ab83db0131cba30e27596fb3a6b78af2e22e942ed0f28ff521b72f241cfe7467" => :mojave
    sha256 "292555163436269437a469eefe7730e86bb4ee6537edfd25395ac87ffd909c35" => :high_sierra
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
