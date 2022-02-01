class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.01.31.00.tar.gz"
  sha256 "5a253c289141d19b8c6fb05e4d12a75343c62d236f98dbbf6af4a50dc0550d90"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "60d2cea5bf3e35085d0013eb8ddbd20572ee69f47d141f384a933405ba7cee02"
    sha256 cellar: :any, arm64_big_sur:  "0de846533c15bc85215188bd4239dc522db78746d7ca3c9adc1d2ec930697cca"
    sha256 cellar: :any, monterey:       "cd18f3782d034306d70a087d720ecfbf8a9afc157c3e97fed9b4d41d0b9b626f"
    sha256 cellar: :any, big_sur:        "e379fc1a8cc4fed528a3a5edba85220b2fa7c28c8774adc72a83b8c6e48c8268"
    sha256 cellar: :any, catalina:       "6e72f8d50cc290853e80f35af1bced6a60a175932ecc2b3d54abad29e8ca9ceb"
    sha256               x86_64_linux:   "3791c145303dc08bdfcb19add31a49f16f8c5bfbcc5d6cc899753e3eb256fa37"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "# t_test" if OS.linux?

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_EDEN_SUPPORT=OFF",
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
