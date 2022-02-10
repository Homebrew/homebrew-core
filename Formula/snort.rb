class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.23.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.23.0.tar.gz"
  sha256 "faa450152a52e4ea6deb388476585fd976a544d8916e728f4406751b52885541"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e36eb77f7df48562aaf6f5f2bc8967467d51979b294ca12baab580f035ff9367"
    sha256 cellar: :any,                 arm64_big_sur:  "11086f62db8b7d102d0b436d7aaf1ca3c7a9a7de5820ccd49edd9a5d2e321e3e"
    sha256 cellar: :any,                 monterey:       "9f8bf890a4702fb5ce5b797ad783201d932dfdf47a06ba1d89012738a773ce60"
    sha256 cellar: :any,                 big_sur:        "e1289c7cc7b4c3250dc6d7befb31172d18bd94926c8065f88a15e0b72db90a0f"
    sha256 cellar: :any,                 catalina:       "fb86dd78a608320031bc342bcb6600f86432b2e749a6d342725e75498be53d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16fac975b6fed56a07b6f466a52f584b5655917ac55d6d6cd38c3b25e739fb8d"
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
