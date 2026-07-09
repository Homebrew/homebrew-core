class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "https://github.com/jmacd/xdelta"
  url "https://github.com/jmacd/xdelta/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "ba2c9676b325f1958e504a60a20340145b8073d5f8664092de17389e15a93199"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59e9b3265d1ed3eaa7acb45f2ae8db76c706fbe49f849e92fbd426d13e6182e2"
    sha256 cellar: :any, arm64_sequoia: "be26e483322fdec244a96911ed8bace807f1da8b4a1275a604192264ae6b4e26"
    sha256 cellar: :any, arm64_sonoma:  "e9ba02aa6039dac4e32b2198684c6fd7a88e3a3ba8beff1de70841769bdfba9d"
    sha256 cellar: :any, sonoma:        "a2328d725a6ef8abcc7e475957fc0972e42fcb65a56826e7b7af52a2bb9ce059"
    sha256 cellar: :any, arm64_linux:   "87b7623b5ed5bbdf3a09ce88a6a221ffe9b45dca659f2dc50911f7cf0678647d"
    sha256 cellar: :any, x86_64_linux:  "e5631b4554f80646caef4ab1a36ed8ccc08aed7ea133ca41433f445842e2f0df"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "xz"

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
