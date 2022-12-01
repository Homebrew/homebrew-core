class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.11.28.00.tar.gz"
  sha256 "bce42b77d60ca01dbadd4ae38a569216ca398b11001c5d1cf950481425317a87"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6de2df92a66d7e5fe9d1a416bd27f7d5adcc2fc814580a92b93cbe4b0607e029"
    sha256 cellar: :any,                 arm64_monterey: "1c7e1b12ad131fa38e69c53cc59a94fda8ea9160626465ad6436c78d1fe6723f"
    sha256 cellar: :any,                 arm64_big_sur:  "6db675b1b30375b2571b4d0a2eab4edc1ddd8f16ba67ac64b5202e7befdf1406"
    sha256 cellar: :any,                 monterey:       "28d1f19ee299eadadc15c805fece0a7838da02c92ad6b6f3505d9df82d81ce0a"
    sha256 cellar: :any,                 big_sur:        "f84753c40302990567b9d450ff440a0050602cd0563de4b4fe4a233ccdff697c"
    sha256 cellar: :any,                 catalina:       "bffb34718f3eafa805fc9c72a3cffa1d7845720e016ec0b58e99076138719bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cebe9a04487290fcc46001a4a2c1aba18dfb0c6af07aaa21a857ee41ff161a0"
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

  # Fix build with CMake 3.25.0. Remove when patch is merged and released.
  # https://github.com/facebook/watchman/pull/1076
  patch do
    url "https://github.com/facebook/watchman/commit/903c5a5a7c328ebd6e528cf79d7b61152ff9a456.patch?full_index=1"
    sha256 "afec5e417ae24c35317db5d7fc178048dbe2bf11be9477a105ef390d0884bef7"
  end

  def install
    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "#t_test" if OS.linux?

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

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
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
