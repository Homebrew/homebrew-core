class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.62.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.62.0.tar.gz"
  sha256 "1f18936da65d52702f75e5b9ffe2cfbc9c9373201801ad275f6e636451f7e06f"
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
    sha256 cellar: :any, arm64_ventura:  "6d1556e40811bed0ff864753914c0c56bdcea04c5d7fa87e513b97ac88cf6a3b"
    sha256 cellar: :any, arm64_monterey: "6bd03726e25080dde24ed06c945f1644a60cd15edf15f10fcef927c0736398ab"
    sha256 cellar: :any, arm64_big_sur:  "6962da78f904d1773ec2dda6e4f165beb72c928c7a7f0e621a38f5b3943c0395"
    sha256 cellar: :any, ventura:        "b6a228727b3d75c7fc527e930896a77a65ca943f541aee5b64cc615b7592141b"
    sha256 cellar: :any, monterey:       "0f86c4462022ca0d3c93d2dca0ad2524ff68f20b6a7e70244ea6f27a6638c879"
    sha256 cellar: :any, big_sur:        "f266a18ac23295d45c6287855b1a5cc9c4476f00b4d9c2556096bb1aa9ec639a"
    sha256               x86_64_linux:   "a76d91357c48353987241d1d0ab5b1e1e7ad89cb308d64b74cace2797c58a362"
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
