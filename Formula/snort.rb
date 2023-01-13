class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.50.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.50.0.tar.gz"
  sha256 "983497578587c5b1291994608fef70700d7f251461e79ac897751bba57cc56b5"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "01bbd12e1615dc4708325b2fc739e04f21962346794d4884436bd3dc42b736eb"
    sha256 cellar: :any, arm64_monterey: "f0560d959142360cbcf22fb556d19294370a127998ff9769036b26024cf84092"
    sha256 cellar: :any, arm64_big_sur:  "acbf5a7f4ec50e6785465fb661941cc5f22a5f912e2a10c1951464d8818ed51c"
    sha256 cellar: :any, ventura:        "ab9d249f971d5ae5676c18778fa8c62d5beabae8c07c98db5c688981662c6398"
    sha256 cellar: :any, monterey:       "4c85847c0365eecf09d952fdec11c3050d9e310e3a829b90f2cea9a089fd886d"
    sha256 cellar: :any, big_sur:        "4647cb1a7f59bfbcffe43fb504188aca1d88156e0d27e813db0c5c5e9fe9375d"
    sha256               x86_64_linux:   "4f621feaefbfbf8728a35d9c5895f1bc0f8716c3121229c264a1afbde671d16a"
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

  # PR ref, https://github.com/snort3/snort3/pull/225
  patch do
    url "https://github.com/snort3/snort3/commit/704c9d2127377b74d1161f5d806afa8580bd29bf.patch?full_index=1"
    sha256 "4a96e428bd073590aafe40463de844069a0e6bbe07ada5c63ce1746a662ac7bd"
  end

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
