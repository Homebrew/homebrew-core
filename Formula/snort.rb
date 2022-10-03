class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.42.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.42.0.tar.gz"
  sha256 "a2121b12c6961f144af5296c515452c23f8e9d583b029c4b98bddc4223742bd3"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f899ee09b610cca4497151efe3b148abad3dae4fa9943a0c07e29b8420d4536"
    sha256 cellar: :any,                 arm64_big_sur:  "c8720121308ffcd9eee4e372996ebf7cd09c536a73d10cc253e331ccbbe11bb0"
    sha256 cellar: :any,                 monterey:       "9abbb7e81d4eb6bdd41ebf510b18c65e173ec1ce7d187dbfd7c5015137070806"
    sha256 cellar: :any,                 big_sur:        "26b7c86b013d99aa764add8c0c73a32e149852db1f58854770f841a6343fcdb9"
    sha256 cellar: :any,                 catalina:       "4b8f171fe2b946663f0552cd0870c9d08fdbb84502536cae6cd33805f5d5a004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99444cb0083341189517030b5d16158ab86b76a90db794f3272d682f2e9caf3"
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
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  # Hyperscan improves IPS performance, but is only available for x86_64 arch.
  on_intel do
    depends_on "hyperscan"
  end

  fails_with gcc: "5"

  # PR ref, https://github.com/snort3/snort3/pull/225
  patch do
    url "https://github.com/snort3/snort3/commit/704c9d2127377b74d1161f5d806afa8580bd29bf.patch?full_index=1"
    sha256 "4a96e428bd073590aafe40463de844069a0e6bbe07ada5c63ce1746a662ac7bd"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
      system "make", "install"
    end
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
