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
    manifest_sha256 "fdcf665a269a314d2eb24d2778ce5886f97910db1f2f0ae4e87438d6b95fda64"
    sha256 arm64_linux:  "7a0704cd3a88a211ece046a4f3fddfd62b93a18e3be8452649cd585f422c9631"
    sha256 x86_64_linux: "867baafa2fd005452913454c7c399759e9b06c2e96a0f76d169baaa927930496"
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
