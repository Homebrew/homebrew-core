class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.60.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.60.0.tar.gz"
  sha256 "295bbeea93ead7835379d9c9332b1f82f9ecdd3741aeed267caf85bb887126a1"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "082abd246e1e65e3570edddc1fceab9cd016e8ed22d9cd0d26e64319efb96d60"
    sha256 cellar: :any, arm64_monterey: "cab460513439077f3d079fd1147b986f4c956b9b1ac2801f2215c28d7c19f469"
    sha256 cellar: :any, arm64_big_sur:  "1098a6f4ad80abe5357ab8afde570949239f31c031ed9d462ec0237eb21d13ff"
    sha256 cellar: :any, ventura:        "7ba7463edccc08a654d6bd5c2e5ae7192befd98fe0174a8b0e4c4c7e37e73647"
    sha256 cellar: :any, monterey:       "6b870f9a47b208bf363241635781d7d87f86831e1dcc1537b5271840854d12e3"
    sha256 cellar: :any, big_sur:        "d2fb7f6659a2ad4e9161a654b04ad71b3ec34439d93d2a4f80b27d65e2128afd"
    sha256               x86_64_linux:   "15735796b647555cce221b12fe28576d4b005acff538aaaa33d71498536962d4"
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
