class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.06.20.00.tar.gz"
  sha256 "e6bc49a4d0aa067ab7374096f472ccb227561d5121bdb055c7eb1b8040f84ca6"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "693ab0c154f7ee89d3f5f7296fbc97a92f2df07c9ab43610b07546e81d8d5ca0"
    sha256 cellar: :any, arm64_big_sur:  "c625a6deefc88613c83f5642210e931def8ccd71779aa2fa35248b23c6f7a430"
    sha256 cellar: :any, monterey:       "f743f8ffad6c3dbd9bacc607e0abb40936a5e857d7bb8b1bf085eb606be42dc7"
    sha256 cellar: :any, big_sur:        "e7c94b0ab9b7d53cba426749b8ab537a468fae1d87089fa8dcacc4b5312890bc"
    sha256 cellar: :any, catalina:       "29db9189c838d83774d00da092c4848c6ff2e8decf42118ce6b29c9146f5b24d"
    sha256               x86_64_linux:   "2506eac88c0313c2ad6997918e2bcdfbfc917d161d07328242e8c532a7a5fe99"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.10"

  # Dependencies for Eden support. Enabling Eden support fails to build on Linux.
  on_macos do
    depends_on "cpptoml" => :build
    depends_on "fb303"
  end

  on_linux do
    depends_on "gcc"
  end

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
                    "-DENABLE_EDEN_SUPPORT=#{OS.mac?}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install Dir[path/"bin/*"]
    lib.install Dir[path/"lib/*"]
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
