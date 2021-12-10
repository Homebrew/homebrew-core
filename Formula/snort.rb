class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.18.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.18.0.tar.gz"
  sha256 "6e45c16b1815d832b5d6edcd2b705e7838e25c76bfd54b3e86c55ecba6de420a"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1f0389b9b29ee07af79cc0f66d7a1ec4a77bca93cf05d99c4f246fd0b3f3789"
    sha256 cellar: :any,                 arm64_big_sur:  "8aac5090cde88cafb6f1ae8c23cb6b8d7fb67071ac93c3e78fb7cc9eff099031"
    sha256 cellar: :any,                 monterey:       "77abc3336ed594de919da99c3afebdc8ff82ed5f8595108c7278b17aec7de876"
    sha256 cellar: :any,                 big_sur:        "af29191c8817444870bce698a86dd1a5439cd637bd41a54d9cf91c7b419f1a8b"
    sha256 cellar: :any,                 catalina:       "93cf672bde17fbc9632c49ad6380a25f02a40e935586211171212bed8cd4f930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9245f1d80e58cf27dee1a9e2e3b75d4e17a05fc3147d0829182f963174bf7083"
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
