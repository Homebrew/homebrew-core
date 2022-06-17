class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.32.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.32.0.tar.gz"
  sha256 "b93f74c6ee249d68ef09d93af2f052d38d0026ec548980d58eeb5470c3a13590"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4bae8edcc2f6de8020c102cd33abe44ad71feb8e5c98d8ac25f6a2f267070398"
    sha256 cellar: :any,                 arm64_big_sur:  "cef0dd8571aefbf2b7463bfa1a728cf32ec6f1b92215be586d5963241d3cb4fe"
    sha256 cellar: :any,                 monterey:       "0c01de835eadfe5ea36a859463688909d12b14116e44a46c4e20151631fb1360"
    sha256 cellar: :any,                 big_sur:        "812c7186132e2b4fbfb35bf790e58a56b50d032c05b191a8c20200ea26f91bfc"
    sha256 cellar: :any,                 catalina:       "894155b5770370522e48f75c1e8504640d6b0ea7240cbac04039d762fe4d2254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5e1ec65d1eb4214706d5f2fecfa0d324c0ae48a6f050966547d37d14b9872c"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  # Hyperscan improves IPS performance, but is only available for x86_64 arch.
  depends_on "hyperscan" if Hardware::CPU.intel?
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
    depends_on "gcc"
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
