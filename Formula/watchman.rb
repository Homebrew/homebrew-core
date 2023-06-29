class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.06.26.00.tar.gz"
  sha256 "34764e470e1ca68fdfc8db11edad4083f7d584c043b31aab7a40b8d266cf340b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae6b4ac910b75ca8d89e0350c27ae35bd7efaabf7188a98611924573542b1f01"
    sha256 cellar: :any,                 arm64_monterey: "9ed1c3538be315d9779438fc36e4484dff15daf07c36ca2707011fd1f3c1808c"
    sha256 cellar: :any,                 arm64_big_sur:  "3e0a5a03e4fa0f786acaab9100a67ea5ce8b95477e39c16dc705931c1dd8f525"
    sha256 cellar: :any,                 ventura:        "0360ce33da9e54a16d1acaf83dfd765f297cba4cd00b586755a99bb18fd6d361"
    sha256 cellar: :any,                 monterey:       "e93fa3cfa837ae3e2c0013db8f080904d06289f7603c25313ceb3778e4d6da99"
    sha256 cellar: :any,                 big_sur:        "8131c79476e6434b81e2f1dcec39a8b218623f182ab89801c3ff88b9f9f5bb4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8685befcb7c5c2764c7dbe247311d62e789c56edacdf159a2909aeb88e28c876"
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
