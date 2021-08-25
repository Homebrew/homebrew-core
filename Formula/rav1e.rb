class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.4.1.tar.gz"
  sha256 "b0be59435a40e03b973ecc551ca7e632e03190b5a20f944818afa3c2ecf4852d"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/xiph/rav1e.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "80c76875e03241980641acdfa1c25c87e437e7950424fce2304841ef9bd5957b"
    sha256 cellar: :any,                 big_sur:       "45b2b8adc65f38c42d453665f302385df54b251846355d002b753365a0701a3e"
    sha256 cellar: :any,                 catalina:      "e08ce645cc56ed8258cc84c6aedaa7e78ce02ce4fed0ad7032845a2c0052aed0"
    sha256 cellar: :any,                 mojave:        "8ed66c0b3180c82355a8d9201ace97ac281b8dab4bc152ad9e58a855b01429ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80162aad2b4a04b11a6436ff2959cb85239417d483225e415043ba67b28bbb6"
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
