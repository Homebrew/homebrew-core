class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.03.10.00.tar.gz"
  sha256 "047dbe45720f4eec3b8f30de4c3ae07dda7ef1f7e67336ca98490656319c00d3"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "61239e63680208b7a952281b984c08e677d3f70f0526d30f246e595942ffb4dc"
    sha256 cellar: :any,                 arm64_sonoma:  "cdb23c72c2593d1f80ef7158385aae864459ca0a6952503c8bbd245e9138e8bf"
    sha256 cellar: :any,                 arm64_ventura: "868adf2a19cdc0e1a476d023b07dfc10b4b2096e6add203c5c2c9f46bb595144"
    sha256 cellar: :any,                 sonoma:        "4fd2c60301ef4bd91ceb45e6cb810459c50c3e8cec09a22ced77be6cc2c75d03"
    sha256 cellar: :any,                 ventura:       "e05fc68b79a2047a23c10f03f78aac336080dbaa1987f05c2bbcfea5f0af1e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5161c58ef758afca45d880194909b9cb132233f91ffb1f4eabb876ab38b1aab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e63931d6798c5144cb4124f7bb3735eea69dfc5f188ec993cebf00282e9c529"
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
