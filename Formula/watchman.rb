class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.03.06.00.tar.gz"
  sha256 "5e9fcb2d8293e89d66ef0585a20bd20d786bb79abba61ebced260d5f4168d223"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65603ffbc669cba5e9dd7933fdbe098f55da17b90a2640ac2e1452252929391b"
    sha256 cellar: :any,                 arm64_monterey: "e4b769f8928dc7d06c306c66302e6f3022f242d765741a0b85720a9b0cee8bbb"
    sha256 cellar: :any,                 arm64_big_sur:  "d89b5b5eddee98558ccbab14b60c8e2ef52e87c215109baa6a030b12329ae268"
    sha256 cellar: :any,                 ventura:        "f70ae74244602e85d0af9c5196d24aa2478a000e2043a6c2fc0ed6f357bf9714"
    sha256 cellar: :any,                 monterey:       "311c5d61c55fffc3dd14aeca7fe109158b563a3b345af6fb9d2afb90cd778092"
    sha256 cellar: :any,                 big_sur:        "16f80c272bf266b99e17480000bab9475a3ddd962a6c97f07e79301a09ed9f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa73eee563240351d26b3996fdc05f648674f90d38fdf8a1aeb432f8a7857afd"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
