class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.22.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.22.0.tar.gz"
  sha256 "6b14382c31a24fabb68faa207224f8adfd2358f844706e55ad08c3abe6c5aa10"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54483a1cbe00e05b6cd2cb166cbbb8f11a006f0a4a64d7663f9e8b9ee0f1c88c"
    sha256 cellar: :any,                 arm64_big_sur:  "89d8b99f4bf3bea0b8d5f5b141b92155273bc222269301810f1ac1cfdbe618d8"
    sha256 cellar: :any,                 monterey:       "361a79e37de5f7ab5f4b8516d20d615c259dffe7c821a14788cec532eee8f4a4"
    sha256 cellar: :any,                 big_sur:        "10e0b6cb9b6162ec41a13282b02b58081025994dfb14f593e93888b5ae3c058f"
    sha256 cellar: :any,                 catalina:       "ef5c6eb2fdd90bdc3b689167c298b352121943bb0a783cb2e53e27bad2f1c4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "366a76684c43f584879c3d44dd747de93745cb844cb036b825f56ce0894252a8"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
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
