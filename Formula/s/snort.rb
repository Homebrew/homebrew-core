class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.7.2.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.7.2.0.tar.gz"
  sha256 "5dc9beb0e115b6c33ce3cc8bd4a38decfb82c199761233e9ee21401a047e0f27"
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
    sha256 cellar: :any,                 arm64_sequoia: "3fc868494ea43c963cff5158c9e8def60e6751fb669dfb7fb79278af8067adf0"
    sha256 cellar: :any,                 arm64_sonoma:  "734d12bcc90257a6ddf0fbf1a352f5e9acee3d58d7221692858292a0b3e73574"
    sha256 cellar: :any,                 arm64_ventura: "61a203e3765d87b6c7b5a7fcd22a94f0895f8c85d51edb3bf49cc34dc5c0382a"
    sha256 cellar: :any,                 sonoma:        "1eadafaaa6d02c510b5e66b54c679cbd8a13a74950b57bbd0d08006d36c439cf"
    sha256 cellar: :any,                 ventura:       "2f49306b9f6c26fe8d3c4d2912158776d98ae9244c96bfe7202e5572a633cdff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e01bb1207df411a15fdd77b278c4bbc177e38185259cf5424e793043a8eb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a61434570b7329bdc4d33351d6a0a373f41eeabe0d7edec03c606719d338ba8"
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

  # support cmake 4.0, upstream pr ref, https://github.com/snort3/snort3/pull/409
  patch do
    url "https://github.com/snort3/snort3/commit/565f3ee1fc9c62a8943a82f0f52a7973530f9a18.patch?full_index=1"
    sha256 "bcd3ce2d90e98c55e57aba85be879a290976c232e9ab2ee9d45b295eb61178af"
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
