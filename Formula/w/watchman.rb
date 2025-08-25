class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.08.25.00.tar.gz"
  sha256 "a46de84ca115a094afd99943c0384bcb0aa01525e2730b7df512c93bba5cd3b6"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33c8b41f5e083990a40b946cb8b41bca372d78db05ee6693a88c1867d7eee861"
    sha256 cellar: :any,                 arm64_sonoma:  "7f58628c45f84125e6cc31668f6871485e6bdc14d5df36236cba97edb35e19de"
    sha256 cellar: :any,                 arm64_ventura: "430582daa153397f98c41c1077da70a750810dbc308bc83db71d94a988ae45dd"
    sha256 cellar: :any,                 sonoma:        "cdbc7b0557cbe592dc87fc4922903c113e0b973bf9981a2568baac4bef456935"
    sha256 cellar: :any,                 ventura:       "6266cf3f8ce4d790efe1bcfb8f36cf36db187b8bff5b0abd13bbedda03da0ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ce4c2e490034768084cfb43d432f194c2c47f461f86cba91773d04ea9375cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed5a7b0ef2728d9494ce01ab806797bd2110dbbff253670a75fbb02997f6b291"
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
