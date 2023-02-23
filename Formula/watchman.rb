class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  # TODO: Remove `inreplace` at version bump.
  url "https://github.com/facebook/watchman/archive/v2023.02.20.00.tar.gz"
  sha256 "b192a36ca1be43e70d32cb189988c3f801326f344fd160ba439e6a953e49e398"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "686c3a601cb88d188327f7186cf1925de3f3a3cb4226a1b7529fd366751e9260"
    sha256 cellar: :any,                 arm64_monterey: "f1e4a8f6dd73fe8e7a9f7de4fe4bf69a0552307381126dc14570e7674f367efb"
    sha256 cellar: :any,                 arm64_big_sur:  "8e05bf3531ad35699d2c42fcb1fc879e79f3bf2993614876a5269588889229bf"
    sha256 cellar: :any,                 ventura:        "2a954f0ca0f0790970f58ef3c94c490950f25a8f4ab233b047f1874e1b534e19"
    sha256 cellar: :any,                 monterey:       "3c30326495212e0cd46ff16b557e2bef1a83376cc21583b8a74d779f341675a3"
    sha256 cellar: :any,                 big_sur:        "f55df2be4d40914996ffa3246e8ac7925a8bad965bd6745e7dcc9a68611f476a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e1fb1a7a1e7da9418fd5ace6e8852293c544a69eaf7fc3ebbd6fb20f20cb72"
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

    # Workaround for build failure. Reported at:
    # https://github.com/facebook/watchman/issues/1099
    # Remove in next release.
    inreplace "watchman/cli/Cargo.toml", 'default = ["fb"]', "default = []" if build.stable?

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
