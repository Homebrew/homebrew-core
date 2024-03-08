class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/refs/tags/v0.7.1.tar.gz"
    sha256 "da7ae0df2b608e539de5d443c096e109442cdfa6c5e9b4014361211cf61d030c"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.7.1/Cargo.lock"
      sha256 "4482976bfb7647d707f9a01fa1a3848366988f439924b5c8ac7ab085fba24240"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03c3c20f83de1fca64b0e0c67e8eb583a334f30769c047304a6627fcec76c765"
    sha256 cellar: :any,                 arm64_ventura:  "ebbacd899e780c0eaa27cd2adb2d3eba5f1d60d1ea38097601e1ea8991c95c30"
    sha256 cellar: :any,                 arm64_monterey: "5a95ecb310417a49fcd0a488a7f69bddede2ab766345e7a90f28235430c27109"
    sha256 cellar: :any,                 sonoma:         "824a1de49472fc953a0676070611304e00ec69b4292a7d448a8dc94db0519415"
    sha256 cellar: :any,                 ventura:        "1b42472f766a82b42d4b345034cb242a7939ddac1c29dcc761326fe002a87833"
    sha256 cellar: :any,                 monterey:       "851887583386e346690659f508b7785936417d94da7429e0f08e11b876d1aceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e4cc6efb6c1c457be8202cc6d09604a79d158d321a4782a2042b5faa34406d1"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    odie "Cargo.lock resource needs to be updated" if build.stable? && version != resource("Cargo.lock").version

    buildpath.install resource("Cargo.lock") if build.stable?
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource "homebrew-bus_qcif_7.5fps.y4m" do
      url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
      sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
    end

    testpath.install resource("homebrew-bus_qcif_7.5fps.y4m")
    system bin/"rav1e", "--tile-rows=2", "bus_qcif_7.5fps.y4m", "--output=bus_qcif_15fps.ivf"
  end
end
