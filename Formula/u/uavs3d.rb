class Uavs3d < Formula
  desc "AVS3 decoder which supports AVS3-P2 baseline profile"
  homepage "https://github.com/uavs3/uavs3d"
  url "https://github.com/uavs3/uavs3d.git",
      tag:      "1.2",
      revision: "0e20d2c291853f196c68922a264bcd8471d75b68"
  license "BSD-3-Clause"
  head "https://github.com/uavs3/uavs3d.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5981193421a0dc1a92b007040f29ecd6ea88f6bec231425efa025ac4c9b5bbe6"
    sha256 cellar: :any, arm64_sequoia: "6bc8a367ecfc45dfdd775fdcc37bc548f48b513d6b238b4b35e40dfffb75669c"
    sha256 cellar: :any, arm64_sonoma:  "06c9e8ed83571ae4b0da50ee7853a45c20794e5a410fe2b0aa507c30c2dee935"
    sha256 cellar: :any, sonoma:        "58991fea395137141ef82f41434d1cd756da6ce86b2f8a4a93ba8cf7e0d3e0bc"
    sha256 cellar: :any, arm64_linux:   "c3fb940a2341710257bcd352d25059c77db447be37ae53c3d8bee8c64e4e71a0"
    sha256 cellar: :any, x86_64_linux:  "41817fe12f2803d550233a5950c1df6dc9813dbf93ff5c7561b955c2a7ff1383"
  end

  depends_on "cmake" => :build

  def install
    # CMAKE_INSTALL_RPATH doesn't seem to work here. https://github.com/uavs3/uavs3d/issues/42
    ENV["LDFLAGS"] = "-Wl,-rpath,#{rpath}"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCOMPILE_10BIT=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "build/uavs3dec" # https://github.com/uavs3/uavs3d/issues/43
  end

  test do
    resource "test" do
      url "https://raw.githubusercontent.com/YupItzAfi/homebrew-testfiles/d4630db319b16e838473b141cd9da818d7ecee9a/AVS3/test.avs3"
      sha256 "cb51f5d7ea8ada807121a1b812c1bbae64e2ffecea384efa3fda2468b519513c"
    end

    testpath.install resource("test")
    system bin/"uavs3dec", "-i", "test.avs3", "-o", "output.yuv"
  end
end
