class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "06d1523955fb6ed9cf9992eace772121067cca7e8926988a1ee16492febbe01e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66ef57034787b9e1328abec79bb85ca9fd65c5f4a2bb800be9b5a58ecab849a5"
    sha256 cellar: :any,                 arm64_sequoia: "61118a13d9f434197f16808350136c7aafc898526937e3ce2917566e77c2672b"
    sha256 cellar: :any,                 arm64_sonoma:  "d7f57daaf463e8a261e3f2eee9190c2580b3f29c2ab4ea1b6fbab085bc6c167c"
    sha256 cellar: :any,                 arm64_ventura: "9b2e4642fa874e1963150309940c638affaac512d2b02594f27b320d89244465"
    sha256 cellar: :any,                 sonoma:        "9257e1d8cfbeceb7c20c8605281fb69781e6897b7e226a7b93d60c0ea57ad508"
    sha256 cellar: :any,                 ventura:       "5903af836d3c0b3101af86df8463a51616f9a891a9b382838249408f9e7eea3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3876806872747aa7ef41b4091ea601992793169ab3c6eb74fd4b1af05c4b46ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ba1d0927e415f2b24fda342ac7f3ef25f99a060e6c68bd929d147da8ea6a92"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
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
