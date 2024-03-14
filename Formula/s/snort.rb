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
    sha256 cellar: :any,                 arm64_sonoma:   "c3dbba4d2d31ed8e97fcf61a75624f2cc40fe9b5970b1bf8fa3b73d1690fe8c6"
    sha256 cellar: :any,                 arm64_ventura:  "31913b3a7c110d7243d1c19598e4f25a327841fb84c4bf9ee901c33cdfffc9b6"
    sha256 cellar: :any,                 arm64_monterey: "70270a8c57f0b0521cfb639c35ebd357475258efd4a397adb9f00971a2771f82"
    sha256 cellar: :any,                 sonoma:         "374891d0633f97cd1c5f9d6a490951368bc4cafb281746780a4dc2d1f6c64620"
    sha256 cellar: :any,                 ventura:        "2e369f10017477ae2936a86505db26b4745959d79c7616f30cda3a2f69bed648"
    sha256 cellar: :any,                 monterey:       "290d9159599653086953567e824b30b36d3d8bfbf896099cd241ebfce24d2ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2412c9d00c7062d51732b5db3be877aa6992eed007f04358ba9f08a7c7b13a06"
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
