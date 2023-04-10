class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.04.10.00.tar.gz"
  sha256 "d6ae1e09cfc33393337c0f7a60b0dd7a122a4aec551bc73577e4ec5c936ae386"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6a609dc81da12428038187b2a0f4562db45324b57f06300ba2093a55d7f9e72"
    sha256 cellar: :any,                 arm64_monterey: "00e05bdb874dfbd79b407e31d60991ea9873aa6aba72445cc3b1c8ee07d4cbcb"
    sha256 cellar: :any,                 arm64_big_sur:  "9f2ece6cd71f4e02592531db6c090071f55e77c2c4fbf482190996c32d5f7c56"
    sha256 cellar: :any,                 ventura:        "56330706660effb5522bc0b175fef40b75c5d20576b46012be224456de7a3dcf"
    sha256 cellar: :any,                 monterey:       "8dc83888217ed2627047143574cd957d0e078e1820c50cbb9c0bcda3b8f43337"
    sha256 cellar: :any,                 big_sur:        "a300f1add13a4f9a145126468038497d025ff5f47ec00deae98c34b55cf215e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8449eb241829c7d995b934325b0673179050db1f2e4f98923e87f5096dd545"
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
