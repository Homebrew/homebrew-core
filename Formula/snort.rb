class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.59.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.59.0.tar.gz"
  sha256 "b4cfbce5b36ca546aac55a2545468a143643867ad9bc8560fe364eb9e10c074b"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "44a4627a3c38e1fc4e72e4759633420e1b0a3f0010531345c46a7ad32a7e49c2"
    sha256 cellar: :any, arm64_monterey: "03a79e1a1027c4956cddd5b5ea4dad2f1d49feab5f2a53edc60e278ac751ed1e"
    sha256 cellar: :any, arm64_big_sur:  "ca32af8c955b78c724f1b90321eba3b17532e2032ef1e89150977a5fbe9e1fb8"
    sha256 cellar: :any, ventura:        "c183df42a28ba9336d9ac7124cc54371ada3b93f7b10df0137f1335a98405a42"
    sha256 cellar: :any, monterey:       "48ffa23494c2047590dd9343c05e30e04a154a2afd798d0d893c3a016783e247"
    sha256 cellar: :any, big_sur:        "799fc06acbbfe34f9a2766b24de34a51136d5fdcb312c15d9006fdc1bbea4f65"
    sha256               x86_64_linux:   "a7e12e1ebc892187c15eb180ee2c8cddd7c850fa8033a96449cec4f603bac74c"
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
    url "https://github.com/snort3/snort3/commit/02e60e50d1a4a18d27643d5f4474bfc0c4709e14.patch?full_index=1"
    sha256 "25fcf002f9613a1fcc06127c72ed2315c93580a6da2c0afd2e82e081f35dd9fc"
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
