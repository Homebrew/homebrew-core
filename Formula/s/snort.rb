class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.9.5.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.9.5.0.tar.gz"
  sha256 "e2e36a8db2c4c26a6ff58ea58839339260319eba25d0eb901ddb7210f4fa4b4c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9dca3f6d61d22082a6ac55949d4726cec080c2d3b5b34ae09a7084418624b6c1"
    sha256 cellar: :any,                 arm64_sequoia: "9040b23b8d73f6d8cbf208099d3c8782884308b4abe45e4ec53f36e9ecba615c"
    sha256 cellar: :any,                 arm64_sonoma:  "ffeb5451108b37c2f44bc380db28b781a58aa9284dd8eccf761e3eed0bb43dba"
    sha256 cellar: :any,                 arm64_ventura: "90dd12de0929e8e9d495b1da4f172f467e81e9bddcaf461542095d3d2221c5cb"
    sha256 cellar: :any,                 sonoma:        "696607e965c0f0bb10ddd5fc47f1bb2330694780fe615b40dc2c6cf490e3dfc6"
    sha256 cellar: :any,                 ventura:       "bb994b0be6e261857ea18db31070440ff56f2b5809600ed3051e60170b65ceb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713a2ffe2f9ca452d709d8ecf88298993734542d0f27629e02369e4f224d84d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1f3154c416aada5e5042498291517250d3de2ce7f70bbbf53df2eef3270566"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkgconf" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

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
