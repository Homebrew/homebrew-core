class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.04.17.00.tar.gz"
  sha256 "7322cdb75fa019874e76615c0cadc34d421be6501e4c84fd9d5bc7296e16086d"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "499d6c0db942050e98a3f1ebd6aba050eade1a5ae9862c67153baec5faa9a1c7"
    sha256 cellar: :any,                 arm64_monterey: "da7c937ff7f9ee28c137f91719b725eba0371dd6e76514516fa88e5b13ca8f16"
    sha256 cellar: :any,                 arm64_big_sur:  "3c1f9dcd38b9195c7c7be9f1fc40f3783981dc0de7ccfc4bdcd5ad11eb75168b"
    sha256 cellar: :any,                 ventura:        "e704eb00289e9ad886e97445922ef8a1c6169e5fa5f0bc4da77d5761f2cc09b1"
    sha256 cellar: :any,                 monterey:       "6dce147f464841cfa62d6b6262b743a8c8c2145673e645f7e5560a3ceb6f7d5d"
    sha256 cellar: :any,                 big_sur:        "42cf26ac83294c6f8d4809633626089871effc75cb6397c9281a131378511c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c812e68b9eb12d1a8ef52ee4f8a6fe3301e0ac2cad44a577c04bdaab4cb2b11"
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
