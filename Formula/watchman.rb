class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.12.12.00.tar.gz"
  sha256 "5641efb409bf62d63086bae586610931d90b430b8986e9f1e4871cb159fcf8f5"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfcb4130c5f1d871e71f2911bd73b2e0c22e591222ecf533a31b86edce9b1209"
    sha256 cellar: :any,                 arm64_monterey: "410a8e8f8eb82cf7540bd344e6cd363a76e34d44f6c4d3f3610aad1619f39417"
    sha256 cellar: :any,                 arm64_big_sur:  "8194e511a34c25e500d860bf20e16d8dcaebc92a8768dca087f7e2423cc3c755"
    sha256 cellar: :any,                 ventura:        "2bff59e839c454fd4a5410e2aef50cfca5dda9a21e1755422d21bb79877cee15"
    sha256 cellar: :any,                 monterey:       "acf2579897c6cf3bfeba013e8eacf660cf70c4911b872003a09b64dbd8a7498f"
    sha256 cellar: :any,                 big_sur:        "088df05c6501239c62aa39e57b7ac09314fc27ef412106c5867e319d2866755a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf3cd389613a54c8e1846a8f77ff90ac93ee7d646c9adc8f8d2433f4b786cc4"
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
