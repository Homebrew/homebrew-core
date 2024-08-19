class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.08.12.00.tar.gz"
  sha256 "e112c5369accd608d351779342cd44bb8f009729d64f0120dba2057b262ed64c"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3660151611ddcf5811b2b56734dcbef55ee5d021f010c0f7fc24b6f0eb754edf"
    sha256 cellar: :any,                 arm64_ventura:  "fd8742153e37e265e2fe952c34254cc668ba906e21e9c74a6f96583cf798886e"
    sha256 cellar: :any,                 arm64_monterey: "1533ae8cd330be0bd70b4d5153dc9e80aaebb4a85d68faf2a57c54bfd02f7c38"
    sha256 cellar: :any,                 sonoma:         "2a4d52565f7283587d3626453fb26c80f59e81e15141c82d50d71e34bc5e34f9"
    sha256 cellar: :any,                 ventura:        "71bc20f8d5a1b7183d17f3afd60345b5e4184b69c559b20e06fbe0b7829843cc"
    sha256 cellar: :any,                 monterey:       "f643496daad3524f0ab543f4fa5ff29398182f42b5eb9a2ab14043934fdc1727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a8548f200bd20227e7ff42969d76432726c06f86adf18f71b53fdf577c630c"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
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
  depends_on "python@3.12"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  fails_with gcc: "5"

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
      -DPython3_EXECUTABLE=#{which("python3.12")}
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
