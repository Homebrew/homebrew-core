class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.02.00.tar.gz"
  sha256 "660e46da4b7c27c3372ef51244ffded2f348b68d606f81a6f728d6e6111b91e6"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90f31ef7e0a2f5dec71387b07cad150bb65465393850fca0fe4c87617b51c6c4"
    sha256 cellar: :any,                 arm64_monterey: "7f66db02d769c94e249d1848c9b608eab8117123b88cec21e14fa85e16e1722f"
    sha256 cellar: :any,                 arm64_big_sur:  "26c308950a4285040ec78af881b9dce3edd3a859fb3e0c427a40b807d0bff33d"
    sha256 cellar: :any,                 ventura:        "065554b664670d8c64a851e9206787f45797045da37588a7640049b8e70e8fee"
    sha256 cellar: :any,                 monterey:       "dc18e7f4c20e40080186a393ecc2746722463e254e78567299bc44b20f3befa3"
    sha256 cellar: :any,                 big_sur:        "10c4a4099f917b0eb267a3872596c27ae9ca9b1979665893654f03c3c5f20801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc31c1f80697e4714a44acd3e16e9d74ab987d13a89438ef427e170c8cb2c157"
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
