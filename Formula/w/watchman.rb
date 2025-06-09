class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.06.09.00.tar.gz"
  sha256 "0785dd8b41242daf665df8eee3e4f1b9b587d398f88f9ba4a3087bec35f57dd2"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a826ec377130ecae1219e271e33227a4524ea50900110ff46b319199f5aaf9aa"
    sha256 cellar: :any,                 arm64_sonoma:  "da6893bb3ddf974e756e470ce7089a130f74db5dc214a5ff632bf7eab3cbb58d"
    sha256 cellar: :any,                 arm64_ventura: "4039e68c9456d3bf490f8d39fe19b402bbcdca55df310937e5c727af6b48b028"
    sha256 cellar: :any,                 sonoma:        "09e910192a58ec457d8c5dd805a2bf47d54e5ea73f1b79cf4e96a6feea443f05"
    sha256 cellar: :any,                 ventura:       "b163d82c9239cae1e9ebc74aefb1f168aaf119e7ddff6e92972bd77f4ad8d773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2fb1dff4a78144080c4b2af718598640414cf9dbdf4b07d7f3e9914aea0315d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "232aedb6336858387df09d40c28fe21f1942154aebe7c88b5341de7649a298ad"
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
