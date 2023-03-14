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
    sha256 cellar: :any, arm64_ventura:  "0fce5c3e10ba5b69c9b43b9812cab94d0a62d0736db7bfbdda39ebb744813503"
    sha256 cellar: :any, arm64_monterey: "ea60b75c2debf8d1f89945cc3d09d2dd231eab790297a13959907c3d9d7434e3"
    sha256 cellar: :any, arm64_big_sur:  "fca8e03954caaab22373be1fc2a8fbf1267d2a416daafd3bbb4562b12f98ff5f"
    sha256 cellar: :any, ventura:        "21b7f54bc035a33a9f0844cf9ddb821aeaae4611020b7c1407459872525dfc22"
    sha256 cellar: :any, monterey:       "8fa0220253242fb308631a11b345df1e284592d0529811e5e056836c2e391c5e"
    sha256 cellar: :any, big_sur:        "a5f82f5c7243f1c6ba5f835189315d96f78e9691da49bdd24a8338b020ec3523"
    sha256               x86_64_linux:   "72cdd4e1183067b7f715196b78cff93744f3265c386dab51de4003a04b5245a1"
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
