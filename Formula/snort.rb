class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.50.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.50.0.tar.gz"
  sha256 "983497578587c5b1291994608fef70700d7f251461e79ac897751bba57cc56b5"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12916b86f42c9c520c8ecef6ab8af7fa77200a7f090e549b691474d29745ce17"
    sha256 cellar: :any,                 arm64_monterey: "1c60954a54a6f1def3ccd9444c33948146913c5b4e201e39abd227ce9d3e7dba"
    sha256 cellar: :any,                 arm64_big_sur:  "cbcecd873742eaefdf268b4f2733bf8dccaba1455dcf1639f07e014800b67418"
    sha256 cellar: :any,                 ventura:        "3a77e076e0a457c2ab321c93ca4f01f00c6b13cc6f584947c5c960949ae46fcd"
    sha256 cellar: :any,                 monterey:       "b57831af982c623bfcca8200bf83b0f5de0e5ea8b0c8c5f4b39b87df352d7bd1"
    sha256 cellar: :any,                 big_sur:        "c4627affd0d3dfd58ff4caf63947f1e637a350ae0080fa0e42e25ec5f225ce66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d577cb8290e2a872a85dd68ddbb236b0f40050a580aebe0d859c04f916db3454"
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
