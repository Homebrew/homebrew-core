class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.25.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.25.0.tar.gz"
  sha256 "8e93a580aa9bb71ed531fc891cec50471476f0851ea61ba569d2347d8f595f09"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3625084d70ec93ab96f75291a69d08908970829089245d35dd75fb7b8f1d1bcf"
    sha256 cellar: :any,                 arm64_big_sur:  "7447dcb38886f13ecd2ef1014ef0fd9d9f4f8ffd2e4a0af19cc601041f02f438"
    sha256 cellar: :any,                 monterey:       "d78b2366ce31c0f9ca977e11f05c92d14cf1c3fa905aab1103ec2985fde6e56f"
    sha256 cellar: :any,                 big_sur:        "07655007652ae5e549d4cda7463a9e98557a708fd57977b1f9fbbb560995cdbf"
    sha256 cellar: :any,                 catalina:       "a4cbbce15004fb90450136b7e0aff4ffb1c62e88f8bcbaf586064d72b5c5be3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66f12547e365fb8f717cda169112d2c48c7188d7436975408658a0e34f56ceb3"
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

    # Starting with flatbuffers 2.0.6, the function flatbuffer_version_string was renamed to
    # flatbuffers_version_string. Upstream issue at https://github.com/snort3/snort3/issues/235.
    inreplace "src/utils/util.cc",
              "flatbuffers::flatbuffer_version_string",
              "flatbuffers::flatbuffers_version_string()"

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
