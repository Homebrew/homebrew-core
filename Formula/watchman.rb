class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.03.20.00.tar.gz"
  sha256 "b711bffed3157a09ebdb8774ba4bf80e121086f307c1e7f4051c8f298a12cfc7"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55217a356d3525a0f494cb6f5c849c6921afdc50545f666cb2a75618e6874c16"
    sha256 cellar: :any,                 arm64_monterey: "da45a4d245046c2e8ef855821b15a024c849460f9868dde1f966faa50d41000d"
    sha256 cellar: :any,                 arm64_big_sur:  "031640ba000a0a98e0e74ad93a6fbce663ec3a22183d33a3a3e30ee6cc59078f"
    sha256 cellar: :any,                 ventura:        "bcd8a066ae605a7e36f2c590643590e9dd20993795c1495a0a84bdf501045625"
    sha256 cellar: :any,                 monterey:       "fab28f9c0b771afe4df70c6479aeaba4fc827d2ebf3bb5fa3020d7b172d068eb"
    sha256 cellar: :any,                 big_sur:        "dee5cf0c2f65436c74a5fe1bbabc7b381463e9ef6d8254051c912c1f79f2a927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15228a48655db4f4c1261fc53e14df657b11b678e5f34aa3c151bf24d6615ebd"
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
