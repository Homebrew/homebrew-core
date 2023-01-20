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
    sha256 cellar: :any, arm64_ventura:  "77431c987e8c7192ef04adb20bf382d4acc7b170e07258becc5e4bd54b6ee170"
    sha256 cellar: :any, arm64_monterey: "e54de40051417c3017d139132577f7a7c5c61c0d4411e57e5ea2c3a6b7f0acfa"
    sha256 cellar: :any, arm64_big_sur:  "71fa43cbd29cea85ed0a60644b7982a9f7e772951aeae089f1a93dd0ecb409ca"
    sha256 cellar: :any, ventura:        "13cd22b953156c9704d6aca38001d7674e1cbc4b53d968fa11915d4e23ac20fd"
    sha256 cellar: :any, monterey:       "2994e9a2aa5a5f392604f74f5dd037f02b1824004984a4a90915be5a02413b24"
    sha256 cellar: :any, big_sur:        "5a82986b1edb7f3579de0585644d0443b8c426534dba33d72f51b585ca604d2c"
    sha256               x86_64_linux:   "0e17ceb4f6ff8e78fd2f91639f5631780ebbd168a22a7a5ff25615250b67fc99"
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
