class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/p20201222.tar.gz"
  sha256 "ea55757624c1de73cbe83e99c000b134c55008ca7e684eb1620e1b35957cb9df"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "fa8c012e3cdbbf325090c8aac4f6d7e5f2e4eaedeab7421caece85919b14d826" => :big_sur
    sha256 "ee813b17cb949b695b9a199598b87370decbd7b9b2bfa1400aacd5542c2f73de" => :catalina
    sha256 "047aa3d9eb50622a2f8ebf34559393d8d7b276989ef0329ffad94933eaca2060" => :mojave
    sha256 "042c41714f694ce482a1405b0346f14e69607c0cea8285a6563dfbf2f899aba0" => :high_sierra
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
