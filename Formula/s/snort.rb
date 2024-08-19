class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.3.3.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.3.3.0.tar.gz"
  sha256 "6f56c02d642ae1d43ed8eadc18421c60d8de6fff721ae3672df0f16d7ca44831"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84cd0c1d07103adc3f0e00c30efba60642196672e4ce8e7441cca2708afd34b3"
    sha256 cellar: :any,                 arm64_ventura:  "f3eef61f836dca34357e7c05eb49e3640a428e81fbb2c131d4de3b3fa95bfbff"
    sha256 cellar: :any,                 arm64_monterey: "61f7f5cab9ea2bbe0fbb3e1d05fd677bb275eb69e561bced217154be36de0234"
    sha256 cellar: :any,                 sonoma:         "3b2161bf2c7556dc14bc3764c86a1fe7430cdfac5b5c49282277ae9f42066ee8"
    sha256 cellar: :any,                 ventura:        "43488941494d36af16a4965149b286337124a121b5a6986c28d3926b14329f16"
    sha256 cellar: :any,                 monterey:       "591c69a1efb1ae7c45eaf912e58067c4df8ed089463cd287bdb15402f17e3198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cd54c1ef5dc211af5da9b602eb7d3bf1953c64ea53e2e3d82c90239d8b50698"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https://github.com/snort3/snort3/issues/254
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https://github.com/snort3/snort3/pull/370
    inreplace "src/actions/actions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_JEMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      For snort to be functional, you need to update the permissions for /dev/bpf*
      so that they can be read by non-root users.  This can be done manually using:
          sudo chmod o+r /dev/bpf*
      or you could create a startup item to do this for you.
    EOS
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/snort -V")
  end
end
