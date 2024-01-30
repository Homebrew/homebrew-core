class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.01.29.00.tar.gz"
  sha256 "9d6e8a7c1bb475833cc867c8c585c6a2d2158c25e524978ae7e1df9812ac0983"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4c5ab00e6de49e2cba8899a7f35d0c01e5683d831adec6acb924c33e03e3da3"
    sha256 cellar: :any,                 arm64_ventura:  "1e2fde81e754605648ea62d936074ad6a9426eb83320f3001dc7bf211e87fade"
    sha256 cellar: :any,                 arm64_monterey: "eb7bb01ba70a56318ad7f66c3dffafd9c77aebedb8c7af20e9313c5e1c7039f0"
    sha256 cellar: :any,                 sonoma:         "aa8fe8037f6bba784860d1298bc2806b31440d91321b33f668bf7953f815d28a"
    sha256 cellar: :any,                 ventura:        "03d50e35c03ff43d06cacd4cb5d738c2dd4852114829d7fdd140764ace99550f"
    sha256 cellar: :any,                 monterey:       "d7dee7037540e33e03ce357026dac332d0e60c1587e34fc4b647ce8fb3033413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a46ac6d6d2d9e832d952344eb72572ca18cf52ddf848ff532facb1e9fcc171a"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
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
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

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
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
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
