class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.10.07.00.tar.gz"
  sha256 "cb38539b9bdf49351e21115124760c07f0585a5bc5577aac74551fd5879ad85b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5592605e17b4dc4736596e76220446358dad99eeea510b33058735fb7738c7a4"
    sha256 cellar: :any,                 arm64_sonoma:  "7062a6bed313a5404f8c4a5a21ee49632f675d131c28a2aed8cec38ad4c16124"
    sha256 cellar: :any,                 arm64_ventura: "80202924eea037442b52d9a294ee987f936eef7c81ce97f64796a0c344f0f1fb"
    sha256 cellar: :any,                 sonoma:        "ee1270fc8b5011ffec7dcd288ddc647b526b2d52bee6b6861ee5a096c96eec02"
    sha256 cellar: :any,                 ventura:       "fd542dd7226f069609f36ca657f4cea4f915a76e29658554b3b902b39016a64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6856615b636ce197b87d4e222a5f40df35f362b65f75bbb0dd16efed43101d"
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
  depends_on "python@3.13"

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
