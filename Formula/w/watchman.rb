class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.01.26.00.tar.gz"
  sha256 "44af7ef7bcb16b8edabe022e1aee395f9cb19220577e6dec28f955792a74a974"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8736dd3b9092eb68a6ef2aa774064f6583ca17528617477f106f3e8020f8554"
    sha256 cellar: :any,                 arm64_sequoia: "7059f5d9723128bfee6d0192d222f25591bbc7ce6b05c0b8fe7f3d7e5f75cf1b"
    sha256 cellar: :any,                 arm64_sonoma:  "5c2602095c42b8c91d06202f9183c603b4590161a4cca8620c393a4a998133ad"
    sha256 cellar: :any,                 sonoma:        "10e9e856ae379b3a8f3c647b7ae6940cac6318b6d6e83ea6cd8489da075c9e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f6f44cdb927b22fd84628c69291de2ec1d68880a7f170bd19ff22baf9efaf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac52e0bcde511e8d9667a9dc3078694b12be035e997458c0e3b74cc8ec751285"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
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
  depends_on "python@3.14"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  def install
    # Workaround to build with glog >= 0.7 until fixed upstream
    inreplace "CMakeLists.txt", "find_package(Glog REQUIRED)", "find_package(glog CONFIG REQUIRED)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.14")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_USE_XDG_STATE_HOME=ON
      -DCMAKE_CXX_STANDARD=20
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
