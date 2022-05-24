class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.29.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.29.0.tar.gz"
  sha256 "becec36b57af3d65ae8289b73cd6d56bf8bde774539c74b35b0ec2262a587281"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2cb417de99c567abe41a665f73f7677087fb4cf432be99ddd8d1ed0095f395f"
    sha256 cellar: :any,                 arm64_big_sur:  "d3332cb547cf4a13e88b7ff0c8364f95e5a345a6798ca12df9912eec0e9b7bfd"
    sha256 cellar: :any,                 monterey:       "554d5f3fbf00b036673dbd37c7b9635e2bc189a73d60201c160c77584aaff23b"
    sha256 cellar: :any,                 big_sur:        "ef88700ec764e72bf02991cd705c57acd0beccdc3c8f42a341e1fde498b292d1"
    sha256 cellar: :any,                 catalina:       "fba57255d92245ae315406ebbe2dc9bb84d78cdc6c2a2cc3a32a4e20415994a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3787dfdab8074fcbf55c6256ec9c40fc09618cbea4cf7f55d6b6c8c9f8cb7a3e"
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
