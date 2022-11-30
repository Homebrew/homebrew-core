class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.1.tar.gz"
    sha256 "dd12132ad9dac229ce00a9caad132c4ad23d7db2b3ad4b5a59e89658fee04d9a"

    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.1/Cargo.lock"
      sha256 "da13dcb2ea6bc0212b077a2e2e2e55b2a674a0ae683b7a2c4cf3e4f137c920cb"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "39120d6a039a8ae1c98217a7ca61662a9dd7e6ce17ba9889c0dfd690cd403ad9"
    sha256 cellar: :any,                 arm64_monterey: "15486f6308ce05ee89ee4d1c96d5165ec1851ec66578d53f06cc8e19b34efa14"
    sha256 cellar: :any,                 arm64_big_sur:  "b0725e463e742f65eb6c88d7115f61fec0bf60f01139c169e2a921debb62d5df"
    sha256 cellar: :any,                 ventura:        "1030cfe47165598db33c1530da5316a815173c268de24c8ffa4a55b1c41335a3"
    sha256 cellar: :any,                 monterey:       "6255aebcb8ec74ee0370390fca79fbbeb2c8d68058e2f7e74910ea526aa7dafb"
    sha256 cellar: :any,                 big_sur:        "54b40a66c3d97249fbeaea13f3ec5d34ac2faffd95b5a4413c98da29dd1c593a"
    sha256 cellar: :any,                 catalina:       "8438c37d331dc244af0680314fda8b4eea803f22f8aa108e69decc785d452be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a078bd4ee14de7dd73b29b3fd4e91f05aff309d780a328df76486783fdf1b0d3"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    buildpath.install resource("Cargo.lock") if build.stable?
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
