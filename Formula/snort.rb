class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.57.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.57.0.tar.gz"
  sha256 "cec779dde2fbf7e3d20b721c04b89f6f84ef663bf1afba06535188e7c766721c"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e457ff0e9332a9defadb009601eb5c386a2c1610c239085c0c762b6b40136c42"
    sha256 cellar: :any, arm64_monterey: "8082ae288f302509e1bcd4b6f580f3619f0dcaa7276b6c2ad75b95d89b9a7b06"
    sha256 cellar: :any, arm64_big_sur:  "2cfe996bd5d8f2864c5d0fe894c8f002eb1830a982ce09a9aa708352a2c69721"
    sha256 cellar: :any, ventura:        "59faf48397a7b336587cd2bc37c9333ad1d2267ad71c62e556b545ff3af8e4db"
    sha256 cellar: :any, monterey:       "163f9dbddf76317bd8c89b7bef8d600c3c44ea841264fcaca160e36fcd847b1f"
    sha256 cellar: :any, big_sur:        "f26865b8dc0e781b6dc72bb20bb1dae9a9148f1f5fb52659d29d0cd8b0055937"
    sha256               x86_64_linux:   "db2c6fe74445212419fa284bbd4c373ed24284e12b8f6a1249f8e0257ac90ee5"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  on_arm do
    depends_on "vectorscan"
  end

  on_intel do
    depends_on "hyperscan"
  end

  fails_with gcc: "5"

  # build patch, remove when it is available
  # upstream PR ref, https://github.com/snort3/snort3/pull/286
  patch do
    url "https://github.com/snort3/snort3/commit/2b498993a47c728c3e273b440266eb40e5aa56c6.patch?full_index=1"
    sha256 "fb93fe6bf01f3f7d3479c25f2ebe52f0d19b42574b608ec15451c3397906139b"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
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
