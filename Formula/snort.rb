class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.16.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.16.0.tar.gz"
  sha256 "24ef65fde4d2d56061c4f2054caa8a807e26f00892cf9e724ad1237ec2285fc6"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "85f07ee0d789b525ace1f8a2dee2614c9d7f8d33b97035147894e323a3548d3c"
    sha256 cellar: :any,                 big_sur:       "4642fb25882260b5d8f744ff566d89cf6ee5679c670c5e3b6cb18dbb68ce5e52"
    sha256 cellar: :any,                 catalina:      "8867d5033aebd007a7e9d7f0f1f34dbcf14c593e293d00169028a7f875b4a9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b294672bfc77986d186b14ab7485ef4f788daa4225b9538466c101f1a2fa3a97"
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
