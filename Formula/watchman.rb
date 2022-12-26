class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.12.26.00.tar.gz"
  sha256 "adeffa47eefc519236ef66e75567b831d962d28573aa1f81f14dcd9589edea18"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1ca5827d6b18b2bcc82ff5583b358ee55734100fee10b7976eb8a38d2a49beb"
    sha256 cellar: :any,                 arm64_monterey: "d62cccce8a178acdf2a12174fbf72fe8e4c1178676a4897d11f2e8410bde7f66"
    sha256 cellar: :any,                 arm64_big_sur:  "534ec7e288dac8f744965f4a1543b48257302dc936ee1150a268c01872decba3"
    sha256 cellar: :any,                 ventura:        "8b075be4711f2e6958cf5555172c5425e9d963c60f6c9e4bbd85e2fcb0bdad6c"
    sha256 cellar: :any,                 monterey:       "27d1808d507ac9c0b0f31fbc289370770fad361497185f81ed43359c40ae30b9"
    sha256 cellar: :any,                 big_sur:        "41cc98e7f714a3bc0c83b675a558e46ee984289adb6d1b3f911643874033d49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329c704aae9fdaeb16371a663d5172f90c747633fc659234960657c5c89f7fe2"
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
