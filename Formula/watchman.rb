class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.07.11.00.tar.gz"
  sha256 "9a602f45c4eb19bcbbcb5ebf370223f986a4c0da416909b902ec5373fb1d2d0c"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7580acd3d02fcc6656ed83ff9e9ec1b452420e0ab0d37d3b98053781410602e3"
    sha256 cellar: :any, arm64_big_sur:  "8c5a3378b2a237d676640edbe0643e03b15c13c54a0bc1f03f7260a59d2a37fa"
    sha256 cellar: :any, monterey:       "3828993160f3322c1cd8e22eea2f880c47eede5f51614e70fe548acc46dd15b6"
    sha256 cellar: :any, big_sur:        "c1d24a5d47c7ea11b5acd06750b5e4918c012d4440166d58292baf3a0c767a0e"
    sha256 cellar: :any, catalina:       "d484d6933f171db45bbb17a802e84d903355afee723531810dd7a8c978f2ef93"
    sha256               x86_64_linux:   "877425f2bd406e2fe115201b1b467802585665fad073521e913907b464616add"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.10"

  # Dependencies for Eden support. Enabling Eden support fails to build on Linux.
  on_macos do
    depends_on "cpptoml" => :build
    depends_on "fb303"
  end

  on_linux do
    depends_on "gcc"
  end

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
                    "-DENABLE_EDEN_SUPPORT=#{OS.mac?}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install Dir[path/"bin/*"]
    lib.install Dir[path/"lib/*"]
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
