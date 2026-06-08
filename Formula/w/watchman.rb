class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.06.01.00.tar.gz"
  sha256 "678ad731bd5102f5090fab2cd8abdadeb5d9b18a2e580f7dba03d40f501978c2"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8a7abe08f9485b1492bb86360259ff893e398c168caab025e02c15e0a3183fd"
    sha256 cellar: :any, arm64_sequoia: "53649b36f607d8421bce095429d02e17fd674d954ed9972d7d9e62737bf5423d"
    sha256 cellar: :any, arm64_sonoma:  "ea72dec06784570a6a56cab7fd06f4f4d64a9dc3802cc5dce2fc69dc3d17c9a5"
    sha256 cellar: :any, sonoma:        "a1356aad420ecc3bedf5f9a2418bcb41be4c3527d99a6bed694d660b6355bee2"
    sha256 cellar: :any, arm64_linux:   "de960ec7bd1f0c66d570aab93fe94c07b744a5e1dd46fa9b79d8ad572f116eb6"
    sha256 cellar: :any, x86_64_linux:  "7b535f658dad5c417b2b23d767b16350a6cb1724800c7af5038ec2ad8f29bcc1"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "gflags" => :build
  depends_on "googletest" => :build
  depends_on "libevent" => :build
  depends_on "mvfst" => :build
  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "glog"
  depends_on "pcre2"
  depends_on "python@3.14"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
    depends_on "openssl@4"
  end

  def install
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
