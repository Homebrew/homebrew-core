class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.03.13.00.tar.gz"
  sha256 "a155d45282df466e4bdcdf70d56aa1398547e3b51597b5fd392f04d410e6212f"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "404c15d4d191fb04a2d756762e23f75281b6380dfa11e5ec6d03fc79f10df15b"
    sha256 cellar: :any,                 arm64_monterey: "4d9d73b0533628c3f4c36fb68f9de2e30c544bf97b4a31b128309f68a5368278"
    sha256 cellar: :any,                 arm64_big_sur:  "d36a0916b1d93362c1f2de36cd9992fbd9af16b09ccb6d459fb9ddb10fceb9cd"
    sha256 cellar: :any,                 ventura:        "a6e4d1d0092e568d2b4d05942d934aec9feb73f4220156ed663a017831864556"
    sha256 cellar: :any,                 monterey:       "6db809971a23f8de57ac377527afcb2acee533ff89946d564c52baccda1732b2"
    sha256 cellar: :any,                 big_sur:        "127ab847fded291097dee223b29987f3fb925c3e9c859530f3f8d41488230de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a6fd449d6078c8ff9cbc81247a6253e5c21f955986ee7667c3da5f3ef713e8"
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
