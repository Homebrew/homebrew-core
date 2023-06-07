class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.6.tar.gz"
    sha256 "723696e93acbe03666213fbc559044f3cae5b8b888b2ddae667402403cff51e5"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.6/Cargo.lock"
      sha256 "2014f7d76e7d0d7eaa63158ef5a1a1cea15a095fd5fb79b20b1052015a7fcd0c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a0e10c10070252c551cdb863000fdfd08b3f39f73f6834f8ba468245bfd7407"
    sha256 cellar: :any,                 arm64_monterey: "68d4cfaeb084772d0a204f9ea0349d13a08045e0c9bc8a3b1d863c4013e67b17"
    sha256 cellar: :any,                 arm64_big_sur:  "53745f5c67bf84dfa288eeb3f1e4fdd55a513c797cd6571c01470c32197482b6"
    sha256 cellar: :any,                 ventura:        "67a6ce79473a844710bb6b3992cb3298da921c9689c3e09be2ad09177c5100db"
    sha256 cellar: :any,                 monterey:       "671e5164de0012dcf4e365a21fff14445116fe6832a78235bc7da0763fda94a6"
    sha256 cellar: :any,                 big_sur:        "726efa39a001b22ba36d9edf08e6251d19b4741bb24d6bd10e73f40688b96cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8858d8c96535e94dfa75f15e858b24855034d714950df482d00760cc7fb8edad"
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
    assert_equal version, resource("Cargo.lock").version, "`Cargo.lock` resource needs updating!" unless head?
    resource("homebrew-bus_qcif_7.5fps.y4m").stage do
      system bin/"rav1e", "--tile-rows=2",
                          "bus_qcif_7.5fps.y4m",
                          "--output=bus_qcif_15fps.ivf"
    end
  end
end
