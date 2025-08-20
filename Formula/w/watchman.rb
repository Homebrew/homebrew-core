class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "f9493050fdc5384c92d18f5445e73b3ebca80fe262c5af9e0c70044e56fd96de"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9102b16f3a0659f3afda719064c65407ef51b01af40201db5ec8790fcbead771"
    sha256 cellar: :any,                 arm64_sonoma:  "45eccfdf372aa3df36fe9a35850f4fb0de4ae07a11f96863aaf9a01ebfe4900d"
    sha256 cellar: :any,                 arm64_ventura: "f463e044a8682b0af562488f1d9d1f5e749b675f66847d9b432b6c433cfa5d5a"
    sha256 cellar: :any,                 sonoma:        "5043af207ef8f352d07db9f1effc7b52562b5cd98e5da80bd66cb84509aa3616"
    sha256 cellar: :any,                 ventura:       "18f6eec923d0a3d66e6bd7174b3e022d2e02392cfa3e6c9a9b7ee9d5df7bf931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102dda32e7f0a9966a8384de37715df87677da5cc62ed37ae8a8277c36557daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b05c4cd66d70c6d3be2630fe704c131afcf4a83c480f3d8baae618f28b29a98"
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
  depends_on "python@3.13"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.13")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
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
