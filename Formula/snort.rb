class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.10.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.10.0.tar.gz"
  sha256 "6bd1c2c243ff69f9222aee6fb5d48998c7e24acaa4d2349115af324f9810bb01"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "75c1886602ba92de7e259863ed2a51c6d052a50b224674370015b4002da87bed"
    sha256 cellar: :any,                 big_sur:       "3d14db3d6a83c80857b430d2729816bd46f799056e8269974e7460f63a26135c"
    sha256 cellar: :any,                 catalina:      "c6e210b20cc622800df9af6c2f0356f4b432d9c784334f0f54bc785951f42fd0"
    sha256 cellar: :any,                 mojave:        "c36e66231f8dc03504662da1070228c818383f40e218802d918a7d7d211e13fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf7ae6223cb676119e0f0ac1d6fa12b70ecf5089ed2edf08fd71f047f33e407"
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
