class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.03.03.00.tar.gz"
  sha256 "7fe350253cd9ed6542ff311efaecb59af07002693dd6250520b2f1644eac0414"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "859d7064a50c63ffd3afe41557dd3b0dea9a4b8aa22aa948165f469906fc9915"
    sha256 cellar: :any,                 arm64_sonoma:  "ed751dc1c8f3974eae4fae529bcd11aa91b56bf74e4a1fdf9da17a5d049f4266"
    sha256 cellar: :any,                 arm64_ventura: "586b74e397cbb17f8ed2aff6eaac5adf5b9c1756252af8728323c20aa6a1b279"
    sha256 cellar: :any,                 sonoma:        "2f803224b0d15f348c83a22a0300072a964ebefe26223f28612ef41fd8dd3f75"
    sha256 cellar: :any,                 ventura:       "f958ba7c3bd26acdcb9245a1ddc79fa88d2d6cd287488c12a71b95e36e87279f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123de4d6087d1e3d8deea4630e7a6cbe1312a510122a0c4baf2796b9b6a2af82"
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
