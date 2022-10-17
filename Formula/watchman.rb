class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.10.17.00.tar.gz"
  sha256 "54d2f454e49cc1c44fe5b4712d9f6b38a86323817c8185c66fbaf951c9411f33"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8fb246478c2c5640e1a6fd383fdca6ac8229a6d9cde2601068259b449e3fcbc"
    sha256 cellar: :any,                 arm64_big_sur:  "19b432fc9526020ab9adb3000cc7cf17333d290c63a87c5c9c5d4c504dc0fbc6"
    sha256 cellar: :any,                 monterey:       "f784f333e09c59ab0d5b207e7d7145bcc88df60ea5d7bd02d350f9afb52ff075"
    sha256 cellar: :any,                 big_sur:        "4f5346890ecc2284a6fb451cea0ddb3677a53555a260bf81fae4a0864316931c"
    sha256 cellar: :any,                 catalina:       "8e5ba2fbbdcbe17bc689506265e19592f46032a3fea210588d2dd4cd965a24c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7676fc6fc016cf8a9bb87ef8dc532f0b5a9b233f0b0123ae464df5615b294564"
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
