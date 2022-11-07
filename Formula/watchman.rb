class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.11.07.00.tar.gz"
  sha256 "4d0e1f25c60c92a2b1bab908ae16c89eb4d3b7e94e542811ad3fd78e26f6f059"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ac95895b1ee4d30947be3c95952af0f6122e6eb8f7a0c581bff4859bccc69b2"
    sha256 cellar: :any,                 arm64_monterey: "fb138238805e4e20ad22ed3a5b2bec9dec43221a4dd65754e9b4b919dce74a57"
    sha256 cellar: :any,                 arm64_big_sur:  "4b99d3a95c18e88e4fb4037840895588e3636e3d83ab89772c6affd8c906aca8"
    sha256 cellar: :any,                 monterey:       "64f85493568df616ab8214e0f77eded51964b2a9ca85ac7ca004b464908b068f"
    sha256 cellar: :any,                 big_sur:        "da0eded4e3e968057900f706b0d01e6f970e62aac26103f44d9bf2b77229dc2f"
    sha256 cellar: :any,                 catalina:       "ab284097cedf321c913d67de9997af2f24a32b4040dbb1122f7f24e75d36aedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8789c7a8249edde1764de50edf476022e35d99c842ff503c75ec09eb9afa814"
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
