class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.1.84.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.84.0.tar.gz"
  sha256 "dca1707a66f6ca56ddd526163b2d951cefdb168bddc162c791adc74c0d226c7f"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/snort3/snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77cca080ec795d1a584951978aa36c9cb3f778bf50335e4146a06b7abadef57b"
    sha256 cellar: :any,                 arm64_ventura:  "7e7e02e6b999dc444865823bee078008f2e9b416a64aeed9807b740c93980faf"
    sha256 cellar: :any,                 arm64_monterey: "36512c9d1e913a523a0bef8d4b8a3643b9c5e403ce065e0b9a31e2421214bef0"
    sha256 cellar: :any,                 sonoma:         "308fa873d82d9cd2c65fa14c824bc559908485bdaf79efef8066c24820bbf356"
    sha256 cellar: :any,                 ventura:        "dac8b332dd17859d0d2a79806f79ff3744111ae676b82f826ab1f04999f3e07c"
    sha256 cellar: :any,                 monterey:       "121aa945319785beea9ca3f90558045d7a3740ec44f4d1438cb975c25f3815c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82efb89725e72a1e2722ec5e82f9860e8184d496a40b881f570a43922fe7818a"
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
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
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
