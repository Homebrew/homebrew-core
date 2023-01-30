class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.30.00.tar.gz"
  sha256 "cba9d34837911ce5a62dad2c5c43feb04dfc9f5fa902bb3d9ef676f1dda2c169"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a482600bd74410675324ece66a1ea5de711f2def7c9aeddd91dea3d1d9b64623"
    sha256 cellar: :any,                 arm64_monterey: "5dc2c1fdf578ddfafbfc023f979f4e9d936b314db483f1772ad746e3f18d92ff"
    sha256 cellar: :any,                 arm64_big_sur:  "d125b79370a084f080843e324eb9f7634c579853001dd8ccd4253626a4d2eead"
    sha256 cellar: :any,                 ventura:        "20d65bd3af75442d731a777f97d119e854efbe1e051c91edbe14406366fb98b1"
    sha256 cellar: :any,                 monterey:       "f6467a7cc27513822e72295c72626952b38fae067ec6579640390886adc5545d"
    sha256 cellar: :any,                 big_sur:        "8d0943a5c474fbc9bbaa1ad71f3ab1d2496c5da93e5541462c67ea28c404a3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1257ab53b7496871103d0db51fc7dada80a0a71b6e610e105da17abf5c60527b"
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
