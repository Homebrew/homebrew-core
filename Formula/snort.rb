class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.40.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.40.0.tar.gz"
  sha256 "d787d954f21d4cd6a048e10b8c53c78cb6287ec448108fc573b951639c8947b3"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ff733b5d42a34bd7c1201cc5f44d784cc8c8b01e69f0258c85b7c8046c2c445"
    sha256 cellar: :any,                 arm64_big_sur:  "db56d54b92b9643543c2ed91b4f3c8c606142d04c6d6c049e93129178fa9dfaf"
    sha256 cellar: :any,                 monterey:       "20e1a444c77f26146c10cf8198288bf5c59ac7628dcfa7becf69731a4bdca67d"
    sha256 cellar: :any,                 big_sur:        "02f8c51485ff2d931fc11bafb285641e30db34807b779484379710ea30a4c368"
    sha256 cellar: :any,                 catalina:       "f66ce4ae431c538b08dfd2f9b2fe24fdbb30e79cb1639cb41bcf4ad020311670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eee8ef9668013e6cb29b1ba8629f936607740edfb23f742c02326da3d1614a8"
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
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  # Hyperscan improves IPS performance, but is only available for x86_64 arch.
  on_intel do
    depends_on "hyperscan"
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
