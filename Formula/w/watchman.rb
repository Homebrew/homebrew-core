class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.08.14.00.tar.gz"
  sha256 "aa56da5e9b7957f37af9a41d7f5ff99d6924a1c7b23e8707de35f3b819a4024c"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9db44027e276e6d0d36aa74c00ee9bddc620d2caa2546f5c2275533d3717294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e04780ba6db5254737b8579d36524010e9fd8140bde1ad104e9f0e9dd7272962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1106730dbbabbb535e630ae1ae3432557722aeef9527098fe07d8ce54f4f56fc"
    sha256 cellar: :any_skip_relocation, ventura:        "a6a93479204832ed1a723b2ef4f736b6d3f03e2a9492cea17eaa3e4a366a576c"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc19ea1131f1980c0a78d12e52db5c9567b84145bb980bb5cb18291c2dadd2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0286bf75d9732685554f981645a9371969985a40663c2df88978d728b9f2839e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7830d3e6cc98bfcc9f6daa4afe41c899a59d8cf9711b9d914630812f0d3bcdb2"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
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
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

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
