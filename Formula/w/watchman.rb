class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.12.16.00.tar.gz"
  sha256 "a1c23a9037b651875ddf6436a30faa7c658005994c6900c2e32506e1de665f8c"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63aee0b52d337b94e18a2bfe8ff5be597e59ec2f9118987bf17a16504b5139b5"
    sha256 cellar: :any,                 arm64_sonoma:  "48e107c78b29296025b235bfb34b081b82d416a623a7c9f9bfd982d1ef91a7c4"
    sha256 cellar: :any,                 arm64_ventura: "a33c37108bdb10bb817369887b0fc0c11adb544ac224ae11f23238f28d5f9794"
    sha256 cellar: :any,                 sonoma:        "17ab1895889be71d3a61a3abe8b5109a472d7991debf125bf00068576262f6c6"
    sha256 cellar: :any,                 ventura:       "26c5c8526803b16ff2102ae1346f62055d9dbbe79bca0314743e8cec72b45b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f681e259829f85881c43f0991c979aaf5bfd3f99cbceccf268131f0a2515ed13"
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
