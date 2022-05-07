class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/draios/sysdig/archive/0.29.2.tar.gz"
    sha256 "38ea602085f706af5d07630189216fa240064122650a81456cb092579313ae8e"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/e5c53d648f3c4694385bbe488e7d47eaa36c229a.tar.gz"
      sha256 "80903bc57b7f9c5f24298ecf1531cf66ef571681b4bd1e05f6e4db704ffb380b"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "064c6b7c08ce6aa2d5664d2364c25b3fc0680b7f3fda8835a2040ec4b4dd808b"
    sha256                               arm64_big_sur:  "9046be4e17cffbedda501dd5555cb4686b9cac8a011d6faaa346401c69a3f591"
    sha256                               monterey:       "0a920e7d804e06a0092349581f30d7b5956ece4fbebed5601a590a8d08a03d06"
    sha256                               big_sur:        "03b2ffd477c14e19eaa1523e1fd9b1fbe3b016f5bcfaa1d7c8e3f94e018084d9"
    sha256                               catalina:       "e4828e09ace8aba03ef82fdf232a6182a31b4f9d17e761cf11b555bee5582bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb70a32b4216e74583e16b6931ce5a633092052ee544f0a8b332a090c31bc1a8"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "tbb"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "elfutils"
    depends_on "gcc"
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

    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, the flags results in broken binaries and need to be removed.
    inreplace %w[CMakeLists.txt falcosecurity-libs/cmake/modules/CompilerFlags.cmake],
              "set(CMAKE_EXE_LINKER_FLAGS \"-pagezero_size 10000 -image_base 100000000\")",
              ""

    args = std_cmake_args + %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[LUAJIT JSONCPP ZLIB TBB JQ NCURSES B64 OPENSSL CURL CARES PROTOBUF GRPC].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
