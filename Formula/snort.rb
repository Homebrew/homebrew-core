class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.40.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.40.0.tar.gz"
  sha256 "d787d954f21d4cd6a048e10b8c53c78cb6287ec448108fc573b951639c8947b3"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "95f1d08c65ed23065b57f32472813b412ffc32d596a4c30b573cfce422d8c3c5"
    sha256 cellar: :any,                 arm64_big_sur:  "83b97cfdba2c19c87fb39d223bca36cd51e1ed98d66158c16749012a0219ce25"
    sha256 cellar: :any,                 monterey:       "ea5ce3a33a6bb8f6956140a2e57fdbac103226ec4f315c1d5ed5e8c9338e8712"
    sha256 cellar: :any,                 big_sur:        "29f37ca51043abe965f84e2b5ec11291c18c4674b2e27c6c550e9eeeb0252aa4"
    sha256 cellar: :any,                 catalina:       "b5da452ce2c818ff2bb9ba5d79c12461ce7f2d3295a0e79588d6c81a0f95e18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "661d0c36688697c4e80a20bd94e1394a70b3416e2ab89563e84c3800d14e4c7c"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
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
