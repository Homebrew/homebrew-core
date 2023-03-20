class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.3.tar.gz"
    sha256 "660a243dd9ee3104c0844a7af819b406193a7726614a032324557f81bb2bebaa"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.3/Cargo.lock"
      sha256 "f22049598eb6f9948b4d852850eeb48c1236a7a068692db85cbfe72b94498581"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70f9829400b585aa9a8a3006e849ea6cb3682c01776cbf24d2c8459dae1f22d4"
    sha256 cellar: :any,                 arm64_monterey: "087c194b06a45901f399ac381cdcd50bd61d790b22d9dd40c1c25a4ee70c4e42"
    sha256 cellar: :any,                 arm64_big_sur:  "83fda9d2fc3eda6588b2239968fb5f79a3594140ed573adc102f8591f5edf010"
    sha256 cellar: :any,                 ventura:        "2b4a320e18cb3a43a2f3e1dfcc3c18388e398bbc27766afed8a11c6a06cb33af"
    sha256 cellar: :any,                 monterey:       "f88c6fd1c9cbe20be25f4441c3693c94ffc963defb8f08a8225d60f7310419eb"
    sha256 cellar: :any,                 big_sur:        "5c7dd4ac66c0c4aec4a6541b83d1550197bebae069cacfa7d137928e384e48a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82f681bf8323e27304aaabdfb089c99a06b7e0d8feadbca373679ae9cff52a51"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    buildpath.install resource("Cargo.lock") if build.stable?
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("homebrew-bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
