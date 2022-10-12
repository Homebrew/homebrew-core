class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.10.10.00.tar.gz"
  sha256 "eadfd0826e857338d5b839f7b61c9dad4f836ddcf058f4b7ee2f8294deb6be25"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d0b417008a6a1b92f894c8ab3f9c3fb50f358a522521f16213dbaccadab0530"
    sha256 cellar: :any,                 arm64_big_sur:  "88a87e5dd231e45f2f403ca454181e19ae9b3b41f6d6113cfe83e1bfcbcd728a"
    sha256 cellar: :any,                 monterey:       "a5974893885c994eb31772fa0eeccd016cfa9b1e31c7f7aaf9b1513f05d86436"
    sha256 cellar: :any,                 big_sur:        "9f280ab2ac32c4f8776db5cbd0e2561b949e0d75ba3dca347ca829af951bc338"
    sha256 cellar: :any,                 catalina:       "ae94c926b991e5cbfdf9f44296adb4b8afa9c7381dcefe7d649cf6e39663fdb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "200855d7f7872c99af9932b53e433e12c44062e3593261b0e45515276c4eee59"
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
  depends_on "python@3.10"

  fails_with gcc: "5"

  # Fix build against fmt 9+. Can likely be removed in the next release.
  # https://github.com/facebook/watchman/pull/1064
  patch do
    url "https://github.com/facebook/watchman/commit/224187aa798a0acab9983ac2b96011497d1c7b7d.patch?full_index=1"
    sha256 "3a40fc8a6e67aa3bf3e22d90ecf423a98c198622ed68ccbbf7c0634e1c971e85"
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
