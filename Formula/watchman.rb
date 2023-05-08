class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.05.08.00.tar.gz"
  sha256 "1ac935212440f53b0e027d759eebc68d97ec196b3233acc8b044cd2322cffc85"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4a21347f3f7b9a6e4bcaaaa1d32b4919536560664508ffb9df8f8b7dc746442"
    sha256 cellar: :any,                 arm64_monterey: "1e0500fb749346b6590f06a13d36d638542d6d32c05395cf2745080b89743d50"
    sha256 cellar: :any,                 arm64_big_sur:  "060b498a8f4f64d0ed7692a4891e3006c38373acea7aa727af9d703aa32588af"
    sha256 cellar: :any,                 ventura:        "72a0cd9f77b3543e513a9b743b0ec09772b6e672c0228affc83dbc95efa6a721"
    sha256 cellar: :any,                 monterey:       "5619f8c30658f27f698c6fed8621cb2136b3867834510ceb68639164d5456376"
    sha256 cellar: :any,                 big_sur:        "67bf56958593a9158ba3feaa2ec439f5341e81effc8ba2303b1451706520a0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e6c6bc88f2ae381507d3460406eb9fb24fbcac91e971e3f8c012245eb6b2d8"
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
