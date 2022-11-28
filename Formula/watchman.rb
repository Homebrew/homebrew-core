class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.11.28.00.tar.gz"
  sha256 "bce42b77d60ca01dbadd4ae38a569216ca398b11001c5d1cf950481425317a87"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4aa7bfdbfcaeddc1eeb4ad8b16cb20bbf47869930a8159b6fefdc1a99b06723d"
    sha256 cellar: :any,                 arm64_monterey: "e531cf3b11075ad7c1854486556ab798c69807e065de8937da65dbb1da92707c"
    sha256 cellar: :any,                 arm64_big_sur:  "5d4fd2b7c716c8883b9357857cd38b224d025fbfd3c817daff0ade8037c81759"
    sha256 cellar: :any,                 monterey:       "1991d3c5031c3543b154232bc81cc8175b0377d4915fed0b66a24d14e46a7630"
    sha256 cellar: :any,                 big_sur:        "3e8b8ff38d7c02e7e62f14c0dcd19bb6796956d8c2bc9cbc6fb19ebb1058687c"
    sha256 cellar: :any,                 catalina:       "d562708838a479c8d8ec6a1fb61cc3f35621d8e118b86522ff9791982ef71529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb65b528b5a7ca109bbf22d0114fdb6d0c440be529760c37881202a8bcad9d95"
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

  # Fix build with CMake 3.25.0. Remove when patch is merged and released.
  # https://github.com/facebook/watchman/pull/1076
  patch do
    url "https://github.com/facebook/watchman/commit/903c5a5a7c328ebd6e528cf79d7b61152ff9a456.patch?full_index=1"
    sha256 "afec5e417ae24c35317db5d7fc178048dbe2bf11be9477a105ef390d0884bef7"
  end

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
