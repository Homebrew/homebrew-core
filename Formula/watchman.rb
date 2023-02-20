class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.02.20.00.tar.gz"
  sha256 "b192a36ca1be43e70d32cb189988c3f801326f344fd160ba439e6a953e49e398"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c49fc3eddc1c038885e7f344a5914a76163b050aac3bcb75af45dc51c258dabc"
    sha256 cellar: :any,                 arm64_monterey: "924f3468355154e00207e3e06242f7c7c979e7fd54630674a5f89698ef33e7a5"
    sha256 cellar: :any,                 arm64_big_sur:  "fd5f7d1e85e4547a343b34fbbfafadbc5b244cb6b6fd13657497c042b802c2f7"
    sha256 cellar: :any,                 ventura:        "a6b909bbecdff586fbf76cabbb9e7a628cfb6809d19af934f9b3f851eef093b3"
    sha256 cellar: :any,                 monterey:       "71372389faa1633125ceabe946fa745cd79681c04f34f009b150140835bfb0c7"
    sha256 cellar: :any,                 big_sur:        "7a72f51c6d860c643178a86d2e7c61162ef777313331ba09958bf3101e908aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf64cc496d4ba5b00e9d8b1d86d13d9f4b868dfdc83d49028bb0d59417e12c9b"
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
                    "-DIS_FB_BUILD=NO",
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
