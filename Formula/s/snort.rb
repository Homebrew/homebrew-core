class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.1.82.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.82.0.tar.gz"
  sha256 "64304315e1c172b80cb9fef8c27fa457357329ecf02ee27a6604a79fd6cfa10f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "cf8274bbdafd6535c5863a10365fdd03b5382ca64d2e724fba56cca99124a9c8"
    sha256 cellar: :any,                 arm64_ventura:  "d1309fe2548c0d98cf6d291ececf7032a967a9cb8d47cbcf5498d7b56c8c0533"
    sha256 cellar: :any,                 arm64_monterey: "c3af77a214ddfe524ade3566049ba11903d1e0e18ba74ce2e7a77a96e23d3a22"
    sha256 cellar: :any,                 sonoma:         "722a8481d9b61ed45e8ffecd48e5e2fae3ae2b2a0e83cb544d38fd61726f97b6"
    sha256 cellar: :any,                 ventura:        "9cb479f9c1827c4bad6c65e07b493c5beef75d3af859829483fb35b5ae28b7df"
    sha256 cellar: :any,                 monterey:       "56342a95cbffab5ba572a6a6a6e1e4b45fecbd8ac8ac9ae075a6f48096cc85fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b78a518778b5cce653e4fbd8829e061ee04f295876029aaa3c384686e998c2"
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
  depends_on "pcre" # PCRE2 issue: https://github.com/snort3/snort3/issues/254
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
    # Work around `std::ptr_fun` usage.
    # Issue ref: https://github.com/snort3/snort3/issues/347
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS" if ENV.compiler == :clang

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
