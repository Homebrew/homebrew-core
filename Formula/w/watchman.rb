class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.04.14.00.tar.gz"
  sha256 "bf0c41aa60675bdc792434e8fac356f2669f96b1ec36516e281f1684cb140e85"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6303773a7b2c05ebe0cb559a6a8651bea44eb14130d3d1f0a54e96dc1a1015d2"
    sha256 cellar: :any,                 arm64_sonoma:  "5a4d4a6fc2efb9647023ec18051c8ce1dc5cefd249633fbe7d2e5c06a91fe204"
    sha256 cellar: :any,                 arm64_ventura: "cc0a70a317322cdf0f5342d78051d4de2765d8b44cceed693e46bc1dd14c3fdd"
    sha256 cellar: :any,                 sonoma:        "270d0a034b1c6b8ada94d880429c4830ea7527cdb56be4ad1e577e7875bb19c1"
    sha256 cellar: :any,                 ventura:       "8458b71beba431566c5a30bb230a2c5c6c375f1e96c270357befc78050416c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00bef5ce7a9ab8351011173c1238adb2408d782ab94412a4604d65d66ba0af29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d53952154d4eef378192cd89429d3817a37a45a95e061d582e6a27b01ed16ad"
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
