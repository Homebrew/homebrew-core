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
    sha256 cellar: :any,                 arm64_sequoia: "d4eaccaecbc49ba3451790fcf2b49f80047ea6d5d44d2c54920ef5f817339faf"
    sha256 cellar: :any,                 arm64_sonoma:  "daedae42b00d7e5f8bdcdb8070323ceca5973d3340c0a4675603ac35c15d7bea"
    sha256 cellar: :any,                 arm64_ventura: "e4e9abc511ed3e8aa19c0d6c8af0ac1440fc1307c2cebc70aca84978b1413150"
    sha256 cellar: :any,                 sonoma:        "5f7033fc03186582d3f92b240b47ab8af82eea6579905e53a9976d47505fdb2c"
    sha256 cellar: :any,                 ventura:       "9eb4c95bb775da8504527957e24988f87161f6d5bdc9ace9ccf5f41300c3d8ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e01b4d498839237093796f57262d118359f158bba46948a523ca048c894102e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87d385454cad53cc03168e4e7687b666581eedd07cbfb1729d695e903a8e2d1"
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
