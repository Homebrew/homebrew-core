class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.07.15.00.tar.gz"
  sha256 "a67816e22156d7d90d7421fe2b3c270e86284c8b20065b1c72a2d33d67db61a4"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2221cc3c6453328f219eec1905baa6189e8196ea217a6cf9f0c2d6cb57402ed9"
    sha256 cellar: :any,                 arm64_ventura:  "993e103120384c51901b730b526cc0d90349d8737f2b7e9c9917ae7262f57cbc"
    sha256 cellar: :any,                 arm64_monterey: "15fde8b873a8827bb5828cde0cad9f7f3fec2ecf2c082d1873fb7fac58caf33a"
    sha256 cellar: :any,                 sonoma:         "c9576d828f9ddb886012a215e4b1eca81b2d402b8ffdf90ca55baf5a239299eb"
    sha256 cellar: :any,                 ventura:        "649ce9f26702c1aeecef995528ac0070bb1a3589f68a8cafb719d270a0e0560a"
    sha256 cellar: :any,                 monterey:       "ea4ca3f5cd425a558e595f97aa71346f694a99144a3a96cce168c4c8e0fa52d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a243c89d6507ee214966ac722a3d4e6676532a28791ea561322348126b7879"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.12")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=#{var}/run/watchman
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)
  end

  def post_install
    (var/"run/watchman").mkpath
    # Don't make me world-writeable! This admits symlink attacks that makes upstream dislike usage of `/tmp`.
    chmod 03775, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
