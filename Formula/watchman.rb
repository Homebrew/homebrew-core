class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.12.05.00.tar.gz"
  sha256 "e56c7433b186190b56d1ed86987a1f64c15486bf0f37dd7d38c826fac07e34f3"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "45bf249ee303997d708164392b2e151b3f0b180b131c20e7b226d49557d50c44"
    sha256 cellar: :any,                 arm64_monterey: "382dcb737f38315b50cf53743533dfc881027e255d710e26cbe967f598077ca1"
    sha256 cellar: :any,                 arm64_big_sur:  "9a2f5678c080275a6a1848fdf92a922c1e4f554a04e93164b47f9adc8fed556e"
    sha256 cellar: :any,                 ventura:        "f2cfdee47bb5c2fb44a9f4eddda8951cf6b369293ecbdd5da303dedf46f9d0b1"
    sha256 cellar: :any,                 monterey:       "17e31ce618d19f05deacff2c2bb7935d5fb0b8aaec191093ffcd65c9646e2069"
    sha256 cellar: :any,                 big_sur:        "fa682de748d2fad6cd224afb6280987eda9be084fbd06e869bc781007acc5be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fee68c42b0acb1bde7f2f9de1ba6ca7d59ee5cca110937a9f8b7c01e5c8aee"
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
