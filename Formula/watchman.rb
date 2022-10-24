class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.10.24.00.tar.gz"
  sha256 "87101e751aecfb53b4f96c39e9f11aa4dc46522c18a4784154f8eec6ef760549"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b1ff6dd08a5091af5857422ec4f4c9561f3b54eaba02b904d77569d53524d61"
    sha256 cellar: :any,                 arm64_monterey: "590ee781d97c2ade3bc39024ca7b669be49f5cbb85ef611ef41521d0424a84b8"
    sha256 cellar: :any,                 arm64_big_sur:  "0c95693194f2b682b2ff6022c708c0a7a04564f8a1caff6934dc833822a7a8c6"
    sha256 cellar: :any,                 monterey:       "cf29ae54e6cdee41031ec01ab05d897573702ce824257c4fe4e6b7a382e60482"
    sha256 cellar: :any,                 big_sur:        "1cdda58019c081ac60d86f9bb580f27a3737004746c3bd804e12267ac38151e7"
    sha256 cellar: :any,                 catalina:       "7a50eeafb0e9e7d4ebc0bc9a2687ab4823c2972b808ead1f5e755a7d76ee3618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab612927037e27705240a08ebe724f25df8580cb4306073ec7e1f94f52583f43"
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
