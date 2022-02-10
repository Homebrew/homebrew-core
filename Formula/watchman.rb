class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.02.07.00.tar.gz"
  sha256 "58170288a9c0929de3b44b773a6150f4c6607bb964a5002627505f1e37718f57"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "bb7081f2ccb441b42aa1cc31bced737a8bf555e56a8b90102151404a1ce552f6"
    sha256 cellar: :any, arm64_big_sur:  "ef9423d33451e74b81458d1ef9464c19abc19fd3e34186e9106fb6e792933eef"
    sha256 cellar: :any, monterey:       "41e6ebc80cd1ed61a39895752141783caf76f16dd0dbb93f926323e48ca16541"
    sha256 cellar: :any, big_sur:        "38834b842fd0aad105dd5dd357148fa2a7c8fbaae2e9897f97457a0a2a9517f6"
    sha256 cellar: :any, catalina:       "2fd793d4262cd6cb6b8c83e317307e3f92e9d29095f2f4bbf14e4aa8db5390d1"
    sha256               x86_64_linux:   "8dafb01f5ec502f779325d5f1809e6c066e1c979731fda02869a9b95e7e95746"
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
