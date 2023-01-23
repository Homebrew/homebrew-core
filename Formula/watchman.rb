class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.23.00.tar.gz"
  sha256 "cec952508001c47997d17e804813beff3c8ef1597448105cea99167d46806046"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4d910e479e35ea493da97f79f077c8f01929418c8848060d4426c23bfd21b93"
    sha256 cellar: :any,                 arm64_monterey: "3986f63dd92d153f422983ed6003e44290e2312f3231b81733a30640e64744bb"
    sha256 cellar: :any,                 arm64_big_sur:  "8122fbd0becf5359e160a21aab02ac298baaf947f4e79a5a32c52d5eb0e810af"
    sha256 cellar: :any,                 ventura:        "90c74d7077031356c8ac5aa99d3b393c0cedfdd05400d553d708a0815fb2b169"
    sha256 cellar: :any,                 monterey:       "ea4667c6509cfaa097bce6c12fb7835cb29d8ac2a15fd69e6dbf1198513fc299"
    sha256 cellar: :any,                 big_sur:        "491cecd99139fef1e89c13ae931ee38635e1dd4ea2dec34e578893de070d20b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c359a50a378ed5208cddd27d5532305a6cdb2d194d33ba567c6897ebe106714"
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
