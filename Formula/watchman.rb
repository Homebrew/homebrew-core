class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.01.16.00.tar.gz"
  sha256 "a0678d8ca4ea54bd7c37517671e30d6349d4c3b7dbefb0cd44247db482d73f6c"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e89def365a8c1c932d6ab3ac8bdee584681609ef14d693e0d35f7dff0559b41a"
    sha256 cellar: :any,                 arm64_monterey: "01b7bf3da9b8c43a5f574308b4ec3e82d0ad578012117839ab228087d1ba4a28"
    sha256 cellar: :any,                 arm64_big_sur:  "4ace889d20b3fb8d56902b266affe5c3f173dab4c80320ee52ea535383ea0306"
    sha256 cellar: :any,                 ventura:        "4340ce6230c6aa9a03619c1b386e185be609257702bd212ee7153dae2f453ada"
    sha256 cellar: :any,                 monterey:       "8f72248272c2f508037578898cc764b9c93820563654931b8f78b71b090442a8"
    sha256 cellar: :any,                 big_sur:        "85e47bddbafab33862a6aa39c889307e0400bb1b2864890bb8c83f7831888d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bfc25569682a201473621c7f3c0f78fab960c3bd1b5b9e8fc9f160b00bc6f16"
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
