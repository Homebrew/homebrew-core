class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "8cc7b3e67156a503c508e209ebca8126d561fcfe7a1923f17b216a1f6b667369"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "737fc557be0e00184614a874373e7850a4b466ddc54aa42b576ab45533658eb6"
    sha256 cellar: :any,                 arm64_ventura:  "72b5c1b45f9d85119a96f562788b9b57f573457ff9b9dea782bf168b470c980e"
    sha256 cellar: :any,                 arm64_monterey: "b94bf9b1a9a4e23abacdbf5399ddd33cf2003d8beafbf9018756da86c30b833e"
    sha256 cellar: :any,                 sonoma:         "60c12a6b9a53acad106c8ef14f9ea72583b31430f44a5bf15457e84f9288dfef"
    sha256 cellar: :any,                 ventura:        "8c003540f852091db1b93d3acb13b164372bb4ce6a38dc317633238148bfa145"
    sha256 cellar: :any,                 monterey:       "7039e1e6fd09f09e74cd17f81837732876d42117a10dbd4eaaed8f1a28a333bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859942abac1e2d13dff13680a6effd6898cd5c034ec753f66be24b671bc66618"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  fails_with gcc: "5"

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
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
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
