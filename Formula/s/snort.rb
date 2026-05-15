class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.12.2.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.12.2.0.tar.gz"
  sha256 "43000d6b0e0307bc1a735874d00deb61e8b6a96d074f8cc9b2fe2cde0058720b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "22535016e81034f4128a8437703afe7db861dbc78a64ef851b760fcdf0e5861c"
    sha256 cellar: :any,                 arm64_sequoia: "a4cbf3bf4567436a6064e0001d12f9bc2a105399405fac0792589fee5d1ba122"
    sha256 cellar: :any,                 arm64_sonoma:  "d1ac9a27e6616c50350582b0ae4a97c39930d5c39bbf17e50e6d51156270b4f7"
    sha256 cellar: :any,                 sonoma:        "b124feccfdc173aacaea506a0f445eef9403b4559f244ce6bdb60d989e1b40e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b25a087deea2a558670ecfea00930e7119e73bc74a443f7360d0f94ef3b67bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1807a54fe2f92464e4db0eecdd31f610d58bab960c7776ba260d6dd416c6ba4c"
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

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
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
