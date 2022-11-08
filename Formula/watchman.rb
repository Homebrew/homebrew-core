class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.11.07.00.tar.gz"
  sha256 "4d0e1f25c60c92a2b1bab908ae16c89eb4d3b7e94e542811ad3fd78e26f6f059"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f130d5b1b287458960cd3fea42853daf776e739219b43fdb7221efc17c0dc736"
    sha256 cellar: :any,                 arm64_monterey: "34a1698cc2eb738719976212123c480303eb65efbdb3b9549f369c276b4cfe85"
    sha256 cellar: :any,                 arm64_big_sur:  "b7b2cb5adb2c5e169456e5c2bcebc7bb4eee1d7f88cd3c5c7b0127a1ef7d82aa"
    sha256 cellar: :any,                 monterey:       "22e14c639e0c70dd119b85e5806d955a8606b86bd6cce5a7f734c4d3baf4c3fc"
    sha256 cellar: :any,                 big_sur:        "9efa8e6761eb0b603f6939e25cbf856d8374fa5caee16a3c4077dea236145246"
    sha256 cellar: :any,                 catalina:       "8bbedba347fba214ab0eb5f1e7dc94c5626ed078b0e85c77e458235115da3956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97ed1d2d65cac95a4b2525cbd617d6c21a24516a51b2355597a2318cd0ee71c"
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
