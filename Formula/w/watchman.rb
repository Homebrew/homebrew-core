class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.04.28.00.tar.gz"
  sha256 "22058559e8b68d953399a10d437cbcfc91787732e2980dd7298e1d6fb4cd2add"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0414669aec53dcc09e0023f10dca34591da8f1379af31b28fb527d32e9c572fc"
    sha256 cellar: :any,                 arm64_sonoma:  "a68e3b0a210ba8045f78aabf026d46ab3f1b5ef625696a61eaa2941d96c53478"
    sha256 cellar: :any,                 arm64_ventura: "ec0e1f689a0b9316486d30849b106cf0c7304eeb115eba30fe4cb9013ad7e410"
    sha256 cellar: :any,                 sonoma:        "adcbfa6dbd420f2ec03b0488942269c8731e98b2787d5256b3a718f51e65c7af"
    sha256 cellar: :any,                 ventura:       "d0df95b5446b30acef063bd8fb8156feeedb2b168becdd9bcc15a640d379b94e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "216d7bdde71408c7610f637e7ba51d26b6d56d75fa533f441a63cc8f558730ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f3d31e87e74134452004ecc7ac0960140422123cfd832b10e73f47a783a94e"
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
