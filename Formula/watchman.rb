class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.05.22.00.tar.gz"
  sha256 "8b55674d10743e123f75adf4f0d34fbdaad865285c2bdebe4c9cbfa697a5a5a6"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f3ec5ed7107cbd4e3435e7c59eae079c9baca488f90f41ebbef10e44d468126"
    sha256 cellar: :any,                 arm64_monterey: "421ccc6f5d08c5bf66052693c39b498737b3f3023692f6d47b33f201abb14347"
    sha256 cellar: :any,                 arm64_big_sur:  "4b6cf6e108ee2cda0796fbffb250b940610810daa3cf04221138e5bc34594d89"
    sha256 cellar: :any,                 ventura:        "e1d87a8b6b1f829f735626511ec89d748c732a3f04ec592a1f84e01727e996a5"
    sha256 cellar: :any,                 monterey:       "180142d45e4f11d0439e019ce5ed5b23d9b3fcd93b082f33b655cc7c2d98d12b"
    sha256 cellar: :any,                 big_sur:        "97a9d76f8ccba952da855b14e2348b7c09ba356ff9d432542a0fd733202150eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7f98170f757fe7800bc555be63988bb3c7aad6c163cc1692c496d640fc060a"
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
