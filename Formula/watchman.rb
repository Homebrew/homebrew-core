class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.12.12.00.tar.gz"
  sha256 "5641efb409bf62d63086bae586610931d90b430b8986e9f1e4871cb159fcf8f5"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40a999e19abb0881132905dd187274ccac0ef38e1c98011c8962637c4d3a05ce"
    sha256 cellar: :any,                 arm64_monterey: "6f1cfaa8404756a991d001d1d5abd564aef30873b0ef635f8497a11cc7f06f9e"
    sha256 cellar: :any,                 arm64_big_sur:  "b356696a63ce06a92e1be16e90b2c82ce311f827bfcf8bb30ae948b48dd69266"
    sha256 cellar: :any,                 ventura:        "06e3ed54cb851478c008dfa4d5f20ce498374971dc0254ed2c67297b5913c375"
    sha256 cellar: :any,                 monterey:       "f9186346de58cd86cbf9a0441ba32a80cad058cc13fef6d758f53b820c76ee40"
    sha256 cellar: :any,                 big_sur:        "25536ed68d2ea54640d5becf464ce72a283b1076bb817f3462e24e1d48b9e0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5914c3e392ebc05eaef29b069ed1e7aab8e56ac968d2ec0fa6aef8dff442e2c"
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
