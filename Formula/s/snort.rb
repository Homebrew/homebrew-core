class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.72.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.72.0.tar.gz"
  sha256 "011bb367683ac5eccdef0ce2060d879562c31ca731230d803b8168094e20a69f"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "512c0e03e0f740a00392054775f0bfef955567be5c75b172abf9d7a0813ce321"
    sha256 cellar: :any,                 arm64_monterey: "4836a78d92bf72c459ecca8575a7bedbaa18cadb1ea509445811b9594bcfb0e8"
    sha256 cellar: :any,                 ventura:        "f59b9ece3444da86039f43b2b2ffe316790b058aa5a0e2845cd2d7ba8748ef40"
    sha256 cellar: :any,                 monterey:       "90393f6b9a6b2bcb2533e1e64051ee997cc18665b6edc6a2f4facd43a24ad694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81da271dcf7e7c51aa85650e10efac7457c37f370951031733269ec79aa0e69"
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
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  on_arm do
    depends_on "vectorscan"
  end

  on_intel do
    depends_on "hyperscan"
  end

  fails_with gcc: "5"

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
