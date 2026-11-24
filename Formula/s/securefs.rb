class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d7fac7adc70c09473173aeadee5b7041d7e63fbf392ef40bdd77888590bb12a2"
  license "MIT"
  revision 12
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_linux:  "b5b05042aec54595b5545c3050eddd44ffdf303ac49e1a145a6336d725ecad70"
    sha256 x86_64_linux: "8db7a45b6e3f6fbe5880131e433afc7e94f1a2137d8e18d27a0a66381dba4440"
  end

  deprecate! date: "2026-06-21", because: "needs unmaintained `libfuse@2`"
  disable! date: "2027-06-21", because: "needs unmaintained `libfuse@2`"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "tclap" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "cryptopp"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/netheril96/securefs/issues/181
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "protobuf"
  depends_on "sqlite"
  depends_on "uni-algo"

  # Fix `erase` ambiguity with C++20 `std::erase`
  patch do
    url "https://github.com/netheril96/securefs/commit/ff95e6525aa6a5980ed9e0d45e14025efbdeb2bd.patch?full_index=1"
    sha256 "fcb79c66774a4272e1dc5d1ec137dce0814ab40119927a2eb82095b36cfa7c45"
    type :unofficial
    resolves "https://github.com/netheril96/securefs/issues/236"
  end

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=20
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
