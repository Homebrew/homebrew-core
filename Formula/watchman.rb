class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.02.00.tar.gz"
  sha256 "660e46da4b7c27c3372ef51244ffded2f348b68d606f81a6f728d6e6111b91e6"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "44395a97c294bd5cc306c832205efbbc538d58dc356a822ac23a97910a801339"
    sha256 cellar: :any,                 arm64_monterey: "fe850fe504761bd34f576c04320256dec6126dde0dae838e2b9ffb5b64bfe6bf"
    sha256 cellar: :any,                 arm64_big_sur:  "1b838a5d5349832fd7ad83848e78c84e2666c6c3d0ed14487640dca0d88ee88b"
    sha256 cellar: :any,                 ventura:        "ffdb3f886b921c3b701c0cfa14b76dbd472be76d37600b2ee601cb2655da0c84"
    sha256 cellar: :any,                 monterey:       "735c22d0b6506988aec9fb1f38bc50d8483a0d6873a40043005ba7fec88c2a83"
    sha256 cellar: :any,                 big_sur:        "18c73028c2744ff290f540f91ae8d3a98adf62eb323619d16f812f477fd5f4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f65679f2765e85af627d81dc26eae0925864eebc0d0674e4554f195ca813c94"
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
