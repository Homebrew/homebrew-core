class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.21.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.21.0.tar.gz"
  sha256 "0fe88fd838c8d7dfb249c4335daaea997db819deee60eacc6871bb11f8afa8df"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ca2bc44bf3251e87b16110bd7d9e9494f49e926ecc96ec327c0a94768f45c492"
    sha256 cellar: :any,                 arm64_big_sur:  "c0906dfeabd9e71032e86382400e9a60c974d13e8f7a273c86849b3ef63371b6"
    sha256 cellar: :any,                 monterey:       "9c79adac6c1dc96c0d84014cf2eeef0476c3a8a59444083594ebfde4fe499e24"
    sha256 cellar: :any,                 big_sur:        "10e4be9604659f5146c5a236ce8968d882f36b760f67abf66888bff14fe73fb2"
    sha256 cellar: :any,                 catalina:       "612f567f7a66d85559992d106249b3cecd45d324ee68dc3bef95d66e09d52baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2714dedcd2274f408d4cac63c461eb131906893cedb100132e2f7fd9c72ecd71"
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
