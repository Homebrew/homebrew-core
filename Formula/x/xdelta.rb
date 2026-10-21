class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "https://github.com/jmacd/xdelta"
  url "https://github.com/jmacd/xdelta/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "995319ccb7fe721a523fb3142376f5813093685b1cc302d07018ca97d2584af2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e06ba5f00d39b61c4cecf44a11da88219d448564152518507fd0ab022a4db59d"
    sha256 cellar: :any, arm64_tahoe:       "41322090097c31f7c861e73eb75b967b071dfec9d26acf67fa13088e6b0001d9"
    sha256 cellar: :any, arm64_sequoia:     "1a6a5ce5552fcbd970d7d5609fe0b70d84454b6213efd9989e564cddc5fda4c5"
    sha256 cellar: :any, arm64_linux:       "89a95e3df30f84626127f5a760cf2c212252f49556265a0ef9cf9257da59b729"
    sha256 cellar: :any, x86_64_linux:      "f26482cf7f221f5659c2f103430ad1ca5f8b596ac277fa50935d8c6cf46d51e5"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "xz"

  deny_network_access!

  def install
    # Fix library target to the same as `blake3` formula.
    inreplace "xdelta3/CMakeLists.txt",
              "set(XD3_ARMOR_LIBRARIES blake3)",
              "set(XD3_ARMOR_LIBRARIES BLAKE3::blake3)"

    args = %w[
      -DXD3_BUILD_TESTS=OFF
      -DXD3_LZMA_MODE=on
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    system "cmake", "-S", "xdelta3", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xdelta3", "config"
  end
end
