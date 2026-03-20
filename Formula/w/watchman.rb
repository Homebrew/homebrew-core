class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.03.09.00.tar.gz"
  sha256 "de969937e947f3a2cd86e77adc2f491b3872e326b9d203396a2a04212cb4175f"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a12837411cf1692f01c96a50e0f6e12b985f40e84e2d4a65b1928a82647f15e"
    sha256 cellar: :any,                 arm64_sequoia: "cb65443eaae7cd0543fa70b601ff9338b49fb0e918a888d2ebd911b2a600cbd1"
    sha256 cellar: :any,                 arm64_sonoma:  "d52174ee81cb22e56adccad547a4d274f9e19b0fa03c8cb4ae4ad2c46b144aa4"
    sha256 cellar: :any,                 sonoma:        "6e603ef7a1ff69e91b257ce0bbab54ed1ad3ed4bab9805634d153b36c2f2d3e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "253d6c22df259e199b5f5b15a14d274e7fb5597e34c70fa499ee4274c3ce7e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02abee4f145785860e5a828218b50cee9a2279ee71e1027ddcda084e925c8461"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "gflags" => :build
  depends_on "googletest" => :build
  depends_on "libevent" => :build
  depends_on "mvfst" => :build
  depends_on "openssl@3" => :build
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
    depends_on "openssl@3"
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
