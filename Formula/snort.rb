class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.45.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.45.0.tar.gz"
  sha256 "fec10fa7cb612c43c0bc2c35e087f0674cad07e8c15145a4c8d8cdaed69efffb"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d5156e5f428900bc019b15a86879042677476a3debc28030fdb2ebbf9bf0de10"
    sha256 cellar: :any,                 arm64_big_sur:  "63075a83fa50048dbab04dcffacf4dcc5b30468b75cb8ecb8a8b4a7b085c7a48"
    sha256 cellar: :any,                 monterey:       "b324bbb0a8810c1bac062565f634daf15988387264d7edb7afb9914107781c68"
    sha256 cellar: :any,                 big_sur:        "989a2a554a749e5b44e74c19ea14bcec0281e614d53f9e8a908e699effa066a2"
    sha256 cellar: :any,                 catalina:       "a90a71306c3240db387a4906d23fb1fc61edaf91f4e777257e14ec1a87616406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3d976e0c092d8322bc34c1a0f009940b6249e233573a04906435b7b5128969"
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
