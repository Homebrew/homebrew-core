class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.12.02.00.tar.gz"
  sha256 "445bda6f262cd23ed305f914249e400c7377ebe21ec971a2ace6c1c3dfad5880"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "068d542e86f859808fefa3f0dc5f13f72de4b7a91251b78d30d21a1eb390fb92"
    sha256 cellar: :any,                 arm64_sonoma:  "72e3503bcfdab0f070adf15fb06d2fc0ca076cb69069b789b8a9cf8eaa3f07b6"
    sha256 cellar: :any,                 arm64_ventura: "ba08ee8516860bc65c1897d7129a8ef7868f45fe03d15f0d49ed9e44d1d9a89e"
    sha256 cellar: :any,                 sonoma:        "f990840836d84e9989934dc2f83e7a104df1b00c505a31c74cee3cc3d4c50324"
    sha256 cellar: :any,                 ventura:       "1b72c384040360e9e89bdb7288d839e150ad8ebd95b90e161dbba1da3bac3984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881b34fc214c5f28058629c17973047e577a95443b36a531b8c4fa2cda4fd171"
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
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
