class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.28.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.28.0.tar.gz"
  sha256 "0322ac1c22321eb908b46d36b53ca3eada2d4f7e48deda4eff22d648695b84ea"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8da9b0f6825032d84a1cb749641016d8f0245e44743a74540b21e44e733b612"
    sha256 cellar: :any,                 arm64_big_sur:  "70dfd873dfd57cb9d2a52a64267ce8aebcdbd3c815a42c3b1e3597a682c72d35"
    sha256 cellar: :any,                 monterey:       "91757311d8758867a0b6c8fc5817baabbf28130d445ed26fa6e2274a7bb42705"
    sha256 cellar: :any,                 big_sur:        "f0dc414164137a551d954ebc620dcc9f4d7f8e181edd97e7c37ec2ac1572bcee"
    sha256 cellar: :any,                 catalina:       "2aeafca25200ba1c8377b66ee925f76977a5c2941edc0dff9f9363f45712bef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbbba941a27f613a024e4d175f891ed0abff750584ae85e88546ef36d4e82e9"
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
    depends_on "gcc"
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

    # Starting with flatbuffers 2.0.6, the function flatbuffer_version_string was renamed to
    # flatbuffers_version_string. Upstream issue at https://github.com/snort3/snort3/issues/235.
    inreplace "src/utils/util.cc",
              "flatbuffers::flatbuffer_version_string",
              "flatbuffers::flatbuffers_version_string()"

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
