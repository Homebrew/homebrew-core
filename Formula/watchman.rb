class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.05.16.00.tar.gz"
  sha256 "2d34f33333f51ddd66775c0efd4571d34c4b8e3de1707866a90830a51563ca2d"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "24c1aaeeaa62998f68a1d791dfb401d9d2526bc2b5d70d7a06b058f5fecf763a"
    sha256 cellar: :any, arm64_big_sur:  "743411f442c28b6c2539b5310cf99b19ebbf6844075cb0078ef81dd249368fe8"
    sha256 cellar: :any, monterey:       "b7bc0b14d96c46c5f2bcc5db8a89e6daa7f2331fe7393f95e1ae83c99f694ae3"
    sha256 cellar: :any, big_sur:        "3edad8b4c779e9e140c9ab31e7ffb20473dcb8b9c343d1a29da357453a08304c"
    sha256 cellar: :any, catalina:       "8468b346b5557850603eb50fd2ee22bd58f1fda0255128abd0276ded777f3c7e"
    sha256               x86_64_linux:   "ad29b539ebd2728a292a976128502f8012744e367d6e690099b3732fd1495f79"
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
