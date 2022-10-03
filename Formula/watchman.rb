class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.10.03.00.tar.gz"
  sha256 "998d8aa2cc836335eb342a72b50d5a754fe6b6dbdfc1ddc75a9973d8a4408b60"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f7d53e8f298b5265ca86239c14eca32be8554648a0f9aff6bc912c01baf3e7e7"
    sha256 cellar: :any,                 arm64_big_sur:  "83a1db9fb3877787440890aa1ed74d840e48262a1e722e6a0aeabc892364788a"
    sha256 cellar: :any,                 monterey:       "b67603fcc22019da18cc4807044abc7d800994d452ddfa0d740ca6635924d1bc"
    sha256 cellar: :any,                 big_sur:        "b711123f8eb437b692d08a88342f5206afbac9d698be6fec86b41ddcf5646d4d"
    sha256 cellar: :any,                 catalina:       "9e2cd0c826863e303896c397a15d6ea6e01a321d829293760e0fbf531fe6a1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68eede662f2219cd225f520914f221ae1f91b130a0413bee91deecf4da34bc8c"
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
