class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.02.00.tar.gz"
  sha256 "660e46da4b7c27c3372ef51244ffded2f348b68d606f81a6f728d6e6111b91e6"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e74aa080c8cd8273802b15a7c6eedda6abbdd2f823b99fc2f11ce22f4e326957"
    sha256 cellar: :any,                 arm64_monterey: "f37e06abc58b29dfb8976999f86a1cc03ba8fff8a68b84e1dcbf3c84420a4628"
    sha256 cellar: :any,                 arm64_big_sur:  "df87bf97c9d67149da379f6fd499ae8bd58f12650f2221100160b6b4cf55e0db"
    sha256 cellar: :any,                 ventura:        "0f65e3ed429e26875296b696e9c10b27daa799278bb2674c6801ba9fad520030"
    sha256 cellar: :any,                 monterey:       "8842af0a25680e6fbe49e34113338da8919e6a52ea6343ecc486d215d2799e4a"
    sha256 cellar: :any,                 big_sur:        "55cb234c6164c268d2bd716a4e15274fcd466743d577fa4178e98fb5ea16506a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadb4337f740b39b48b1c50583b29cac8b14aecf73ee045ce356cc4eb4f2033d"
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
