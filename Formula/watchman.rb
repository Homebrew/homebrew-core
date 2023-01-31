class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.30.00.tar.gz"
  sha256 "cba9d34837911ce5a62dad2c5c43feb04dfc9f5fa902bb3d9ef676f1dda2c169"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e4c314b6e937f01f2ca6415b553a7aeae5b6aa63e4cc845214aecbcb6db2579"
    sha256 cellar: :any,                 arm64_monterey: "8179edf721dbe8c24a08b126fc95e55b4622ff733bbd7adcae6eb45c2ae21d78"
    sha256 cellar: :any,                 arm64_big_sur:  "3f6a59e1a8f1d04c9587fae030fdafa4fb3a4e6fe8c28abc8430477ea0d2830f"
    sha256 cellar: :any,                 ventura:        "3dffd899cbb6f18021e015eb0c9cd3e02501b5ae1a0f9c2df9cefe078a41f60e"
    sha256 cellar: :any,                 monterey:       "f05679bd892280daee0933a99708a8da638e72613a02c93bbe0dd73433cfe761"
    sha256 cellar: :any,                 big_sur:        "e899a2f1cea58e7752ce5ed040e7d93e5586e535787239e77b1a219ac81545f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5529db4e8414a186dc9e5a7cb652f115fba68a4fa849740b97351b1dacdd865b"
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
