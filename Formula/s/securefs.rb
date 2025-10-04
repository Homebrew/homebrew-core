class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d7fac7adc70c09473173aeadee5b7041d7e63fbf392ef40bdd77888590bb12a2"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_linux:  "7100cc271128bdbe4344cdcf4da718f7868ce0f79c2859ff9744169d5c2c5a3f"
    sha256 x86_64_linux: "7ab7f0f4fa41b0c2d31f70039a0bd1afbb5ee9ad9e0d854ca2e3738c2d81f681"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "tclap" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "cryptopp"
  depends_on "fruit"
  depends_on "jsoncpp"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/netheril96/securefs/issues/181
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "protobuf"
  depends_on "sqlite"
  depends_on "uni-algo"
  depends_on "utf8proc"

  def install
    args = %w[
      -DSECUREFS_ENABLE_INTEGRATION_TEST=OFF
      -DSECUREFS_ENABLE_UNIT_TEST=OFF
      -DSECUREFS_USE_VCPKG=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"securefs", "version" # The sandbox prevents a more thorough test
  end
end
