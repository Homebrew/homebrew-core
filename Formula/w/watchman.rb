class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.11.18.00.tar.gz"
  sha256 "1dda15fa8f9bb510d6cc3014a5e783dd0d41f3885b539d9f8a8c937d93da9b15"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c96b430a27c127156850852a791008c94ce16afa87f1d8f7ed151a048320024"
    sha256 cellar: :any,                 arm64_sonoma:  "55f403193ea71e98d0757f1a54db6e1bda940b9a796ac7bead0ff69b4cce88cb"
    sha256 cellar: :any,                 arm64_ventura: "714e67a7b7411ca04378da6875a658c93c4fb57198281b2c4d27f00a98a34cb8"
    sha256 cellar: :any,                 sonoma:        "41cae9d097af1ef1f98034580efa364fda841b13902bb0c6ac61742c53ea74e2"
    sha256 cellar: :any,                 ventura:       "f59f8a08ec932e0c97befec56cab828f3975228df182e23cf53ef3ca0142ff17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3403a22d4cdcddb1be0c3eec2150b54750ac16c881f536e538c4a51a52e0b035"
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
