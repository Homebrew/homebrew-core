class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a4b0ceaaca98d25ed062bce0649bd43c83d5ea78d93d1fa4f227a2d59bfb7e62"
  license "MIT"
  revision 5
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_linux:  "9858bb030f35caffa0e1d2bc4e47a17299407726b2fe103e94109e7b563cfbcd"
    sha256 x86_64_linux: "ac836eba2edf511f5070306aa3e70a81c3f7fca475e1e88ef014ff0d811d89d9"
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
