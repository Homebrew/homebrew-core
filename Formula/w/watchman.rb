class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.12.02.00.tar.gz"
  sha256 "445bda6f262cd23ed305f914249e400c7377ebe21ec971a2ace6c1c3dfad5880"
  license "MIT"
  revision 2
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "caa41cb9dc1d7707da7078b7f8a7a1b5fb2d9c5193a744ea035627699e472ed9"
    sha256 cellar: :any,                 arm64_sonoma:  "9b70da1cfde3294c1bd0e498a7d091df78f95eefafae0190dbd9fa7c5c11bcc4"
    sha256 cellar: :any,                 arm64_ventura: "83cecd08b798fb570eb9194a3e2ba7a7149f5b1a5448643439adac5e9f4fb48c"
    sha256 cellar: :any,                 sonoma:        "d32ba4e9aaab9dc10589b7e79cd3d1edfb30f39876fa53fc0f472503c28a4dc9"
    sha256 cellar: :any,                 ventura:       "91d3d3000f0e5cfd67c10c1526b93f81012ae3af4fccc7235b6504c31cc97a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d793f03af48391058490f5bb8516239b101d6cfabc1b288cfbba90428ec54eb7"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.13"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.13")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
