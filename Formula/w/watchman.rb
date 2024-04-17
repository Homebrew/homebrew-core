class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.04.15.00.tar.gz"
  sha256 "6256038507365024e9f17e364448402ad4831035475137dc22c7a47fbcd4d962"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80991ffe7764c63682a8a3eb7ae16c7c67dd7e25377acfb06fdfbf12413f91e6"
    sha256 cellar: :any,                 arm64_ventura:  "de470d6906aa467826feb9e49a9f1c55face98e9d2aa1a6d85b1c515e189eebb"
    sha256 cellar: :any,                 arm64_monterey: "fec434c1566555da40d261263fbb5210c5d8574ac906b9daabe828047dd10062"
    sha256 cellar: :any,                 sonoma:         "4450792ba0268ef54da02b0ad9f1760006575fc4fd022d4a6ff7713e0b796384"
    sha256 cellar: :any,                 ventura:        "aab73bbef976b6566505679572993164b596ece037c752a03edd1395e11c6070"
    sha256 cellar: :any,                 monterey:       "e829d9defab7bdffd8a664eb8f8ef09d5ddf9eed65ea9dec87f7a4b8b3a4090a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d91053f227ffc9844422d7fb897cfde384b2bcb57db93e715aee74a0cf3e7ba"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
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
