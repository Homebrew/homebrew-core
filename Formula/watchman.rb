class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.07.03.00.tar.gz"
  sha256 "ed416dec072c91a27cb76e8fa32903e810135d5b49a584d2943fcd04fb2a4a02"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33dd6f58c98d220439830b6543597d6b77893519218fbb8969db92a2ed626f92"
    sha256 cellar: :any,                 arm64_monterey: "9500d3e7ab4d1a3cfbe05b9d0bc0ea4e14d6dae85324c02d9a9142d199c71a0e"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3313d5593290efb27770369f50ed7d19023c8f18b100a55cd55ba2a6b18c6e"
    sha256 cellar: :any,                 ventura:        "562cc271969a5032ed6a23035df5cea496fbac6065c2e12b99b135b4d4979119"
    sha256 cellar: :any,                 monterey:       "f6a78b8c2d1da4d5353cd190dd3cbad297039370b6c3f9d214ef62b0034d3128"
    sha256 cellar: :any,                 big_sur:        "42ba9fde8c7b4f7809ee8d4cf4737041a5660857908f62caa54df83d8e228e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f093b2923731800a797a24f12a9359a87334964f41d93403749814afcef419"
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  # Add support for fmt 10
  # See https://github.com/facebook/watchman/pull/1141
  patch do
    url "https://github.com/facebook/watchman/commit/e9be5564fbff3b9efd21caed524cd72e33584773.patch?full_index=1"
    sha256 "dc3ef949b0a4be7dd67267eb057fb855926b3708e0ce1df310f431fd157721ca"
  end

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
