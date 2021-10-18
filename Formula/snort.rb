class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.14.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.14.0.tar.gz"
  sha256 "b36b2cd155ac03502f92f2a46ac7e3e2987ac1bc197a2655b1ae8386875aa489"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2ebe29f52d68b28fb55f7d65aea348bc5339d88d738221349cb0d00922193656"
    sha256 cellar: :any,                 big_sur:       "8bd2dc2a016e6eb10e564723b4e52914dc2662313908b0e14ffd1681960f58a7"
    sha256 cellar: :any,                 catalina:      "9e531dc0b5493e33390f6b043b08fc06907d40ee56a9ec65c53a2e96387cd2b6"
    sha256 cellar: :any,                 mojave:        "1c688c1127c1a3da81e8aecfce557c4b3b3814c054637e90df41785f0d900efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbdad733d3bbcdd8a897e2e920ffde92a2ac6fe106661e906e72e9b83aa22ba9"
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
