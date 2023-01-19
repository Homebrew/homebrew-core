class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.52.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.52.0.tar.gz"
  sha256 "351ef4295b54d750ea557bdd5a10c8a04d1edc35003b0d84620451c998591117"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "70dc993ef6f60dc19874ab40493301e4983fabf062ba68def119c15a3b39a291"
    sha256 cellar: :any, arm64_monterey: "5686d6122610fd9e8d8d5585314e5a0fa045161369dbc45e5aed6c5145e3fed2"
    sha256 cellar: :any, arm64_big_sur:  "976a4c5682aaf39133b490ede411e26ad8a4e501b37c5fbb77444baab516fa7b"
    sha256 cellar: :any, ventura:        "bff6ce1f922837656999f21fc5c8467d3bd0dc8de69cc380cb0c15ab63c7a0aa"
    sha256 cellar: :any, monterey:       "af09cace150ec4705d076b76c9b210d48b846eab40562eb2c2554b8214f1384f"
    sha256 cellar: :any, big_sur:        "b75441d5a79de1c1639cf9b2c1da135950fcc904b495f782e60d537c2ebc804c"
    sha256               x86_64_linux:   "d809bc3a18ee9ab586b26a896f967214b091b81278fae32586da93d258a00cb5"
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
