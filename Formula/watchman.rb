class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "d4f772d67932e64a699c85f0c79a9be4e15fe493f0a15655908d88e7d0d39279"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f7eb7cd05953d2412a77703d9b61b5589a7d9be767730a106b596b7078580be"
    sha256 cellar: :any,                 arm64_monterey: "0cbbaedb9e8b54c6ef9db467ba1be591071642f687218478bfbc163688417915"
    sha256 cellar: :any,                 arm64_big_sur:  "823df16452dc6b1b833c15780e270a95df233cb5f721e70bf9068f7a6adea7b1"
    sha256 cellar: :any,                 ventura:        "b37240dfeba7e3f6f1bcbdadf5d557f02f079ecd381e2424b2a4e1f3751061bf"
    sha256 cellar: :any,                 monterey:       "d55f3f3dedc1c4a98b841d6d1a78859f25e8c8eb72529c7df086ac631000cbea"
    sha256 cellar: :any,                 big_sur:        "91521e4d0a16dfb473224bbbe1e2fd6a9ef51e0760ac6b2211453ad21261d457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea446ea98c34643cea3e25a819afe388194f452d8268c2771ef4af5feb136e4"
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

  # Add support for fmt 10
  # See https://github.com/facebook/watchman/pull/1141
  patch do
    url "https://github.com/facebook/watchman/commit/e9be5564fbff3b9efd21caed524cd72e33584773.patch?full_index=1"
    sha256 "dc3ef949b0a4be7dd67267eb057fb855926b3708e0ce1df310f431fd157721ca"
  end

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
