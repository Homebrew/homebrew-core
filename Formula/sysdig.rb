class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/draios/sysdig/archive/refs/tags/0.31.5.tar.gz"
    sha256 "9af98cae7c38273f7429ba0df628c9745bd92c949f444e180b9dd800af14c6dd"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/refs/tags/0.10.5.tar.gz"
      sha256 "2a4b37c08bec4ba81326314831f341385aff267062e8d4483437958689662936"

      # Fix 'file INSTALL cannot make directory "/sysdig/userspace/libscap"'.
      # Remove when `falcosecurity-libs` is upgraded to 0.11.0 or newer.
      patch do
        url "https://github.com/falcosecurity/libs/commit/73020ac4fdd1ba84b53f431e1c069049828480e9.patch?full_index=1"
        sha256 "97fde5e4aa8e20e91ffaaca4020b7a38751d1ad95d69db02bf10c82588c6595b"
      end
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "a7dbbaaa73d3e72c849a0d1c600db4af64c32efd50e72a92be91f1dc841d5541"
    sha256                               arm64_monterey: "c4e71ab34ad98f927b5b2adddce3b607758fecb63a6a8d2b8e6eab740bd2f00f"
    sha256                               arm64_big_sur:  "039d010b447f0a330f84a041fb5c5293c42d12a9933d0ffacce1f209c0d63ddd"
    sha256                               ventura:        "3b7cf7c8297294d080205ffa4a23311ea7110acd592a3451eb33a1e91a94d203"
    sha256                               monterey:       "a7eecbb515fe22f8cdabf452195a5bc49dd7bab1302335c992d74aa863c413d0"
    sha256                               big_sur:        "f0fb5a56fcc9cb39f965b7ff17f9aa9b84b84cbbcfb274420b7260c5f3d23a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a0b84ad26f9af2cffccd12bc5800f657ce27b699ccfc9c8c18d641cb7a0262"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "re2"
  depends_on "tbb"
  depends_on "valijson"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "protobuf"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # FIXME: Workaround Apple ARM loader error due to packing.
    # ld: warning: pointer not aligned at address 0x10017E21D
    #   (_g_event_info + 527453 from ../../libscap/libscap.a(event_table.c.o))
    # ld: unaligned pointer(s) for architecture arm64
    inreplace "falcosecurity-libs/driver/ppm_events_public.h", " __attribute__((packed))", "" if Hardware::CPU.arm?

    # Override hardcoded C++ standard settings.
    inreplace %w[CMakeLists.txt falcosecurity-libs/cmake/modules/CompilerFlags.cmake],
              /set\(CMAKE_CXX_FLAGS "(.*) -std=c\+\+0x"\)/,
              'set(CMAKE_CXX_FLAGS "\\1")'

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
      -DCMAKE_CXX_FLAGS=-std=c++17
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
