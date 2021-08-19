class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.10.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.10.0.tar.gz"
  sha256 "6bd1c2c243ff69f9222aee6fb5d48998c7e24acaa4d2349115af324f9810bb01"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/snort3/snort3.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "58986cae6a7edcb337c8f719e38d38b5c6656414df138814a191135ec6196d43"
    sha256 cellar: :any,                 big_sur:       "5b1749b31605e7c22eeb1f90edc4979b7674324754a2230f7f8d1440bf1aa808"
    sha256 cellar: :any,                 catalina:      "d25dd4a9b0a6d6596848d40de190c59f9b4cce3b5e8797ac0d27a39801bc93af"
    sha256 cellar: :any,                 mojave:        "5aa32bd5221b932274c2cbb322b0315cd42242f626b4b29d2203882739764a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55b8760ed186928055e3470a4ab02134a4765c64faf986cc7e2a8f8a3f18576"
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
