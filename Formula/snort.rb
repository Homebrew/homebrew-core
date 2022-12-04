class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.48.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.48.0.tar.gz"
  sha256 "65df088a8cac11e59f0b71a7f98fc9d21eeb0e31d35280c470c985172947ebfe"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "199f59bf06e26ad0ad5c4aa5036f1455e8d625a6b5d7e037faf941b432e2b2b2"
    sha256 cellar: :any,                 arm64_monterey: "93a507e2b79481de237219c068b143ab903713f01f260968e7afc9558b8933c7"
    sha256 cellar: :any,                 arm64_big_sur:  "33f86a89e02d9db969b1855ed2c7431149b4c94659bbec98dbb7b1ddeaa3ca90"
    sha256 cellar: :any,                 ventura:        "f162d6f5a027a315ab9f21899bd6789af7cc0a2c68482cd761e31ce4938a0991"
    sha256 cellar: :any,                 monterey:       "185f8060e4b0cbba5aa100cdc66ef9d280fb479388410d773f006a24ba3d582d"
    sha256 cellar: :any,                 big_sur:        "a7a642729ea9a06589559484dc0e689f39fb48de8acf36e0d13b4fe77597b503"
    sha256 cellar: :any,                 catalina:       "f9faeca18a043ec4829fddd3bca2dba63bf620040d11aea75331e6ea903fd651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a11e6cb3ebaf823e540ff3c0ac0773eaae26f7baab0ce271078478eb106c77"
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
