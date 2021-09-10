class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.12.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.12.0.tar.gz"
  sha256 "767c8987ddefbb6be18e340d1cefd15cc3de09fb37e5d4adf438cb12b56762b9"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3378719337ee90938e61c5d453e34362037a258c16702229797eb68a54122a22"
    sha256 cellar: :any,                 big_sur:       "d4e6becc84fb994925e6495b6830c9f766d660d634a92dbc0bc43266f65a06c2"
    sha256 cellar: :any,                 catalina:      "09e072fa6338598fef1cd6a21b799c9f0f19796a88a9258d6025a560a533caa5"
    sha256 cellar: :any,                 mojave:        "4e13be31513a7b1bcdf27fe90a68beeff0e0dbd44120d3a288e99ca4c24e87f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7698ae40590d6d6ca18163b7cb91f820083653fa167a6f93063410cf0f1ef6cd"
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
