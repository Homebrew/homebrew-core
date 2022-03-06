class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.24.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.24.0.tar.gz"
  sha256 "b40243dc1158b3abeecc90aa31ca9abe8b8a63cd50f4ea2263043d29b5e9bab7"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5651d4963ce365f158dfc66c63c5c3fd04fccdd0a3cc6c4be3fdc77fdff9eeda"
    sha256 cellar: :any,                 arm64_big_sur:  "06dea4c78b36de6f3736c2ec8d424674855327833e9bdf4a17b9123982c7664f"
    sha256 cellar: :any,                 monterey:       "f2c4233f7639e0db832fa07954d637d6a448fc1130e6691201db326e8956f0f1"
    sha256 cellar: :any,                 big_sur:        "a5453f0a50023d9295722de8f2342aa480fb3e32997613284c51251873a9da75"
    sha256 cellar: :any,                 catalina:       "c9152abbc14905644767164fca32a3ae5c8b3804be354fdfd8fb7492d6b08f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85699ce4d8a953b200bcc2f31222a4fdb1eb0796903f8fcc40c3b96a1add5fb4"
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
