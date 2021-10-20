class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.27.1.tar.gz"
  sha256 "b9d05854493d245a7a7e75f77fc654508f720aab5e5e8a3a932bd8eb54e49bda"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:  "2d91d85c74423736815948c9ea42279167aad86e0fec43b6be5fa4f79d2d2089"
    sha256 catalina: "7300c92bdaba65836b9455ffbe1f8d31076da2cde4677451ffa61c8135e951ad"
    sha256 mojave:   "fb57406caf6ade89e50917434ce9ad7b08d96fa0a805442e3a4ae071cebd8804"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "tbb"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
    depends_on "gcc"
    depends_on "grpc"
    depends_on "jq"
    depends_on "libb64"
    depends_on "protobuf"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    args = std_cmake_args + %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DDIR_ETC=#{etc}
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[LUAJIT JSONCPP ZLIB TBB JQ NCURSES B64 OPENSSL CURL CARES PROTOBUF GRPC].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    if OS.linux?
      # Workaround for:
      # error adding symbols: DSO missing from command line
      abseil_libdir = Formula["abseil"].opt_lib
      ENV.append "LDFLAGS", "-L#{abseil_libdir} -Wl,-rpath,#{abseil_libdir}"

      # We need to compile with C++17 to use abseil.
      args += %w[
        -DBUILD_DRIVER=OFF
        -DCMAKE_CXX_STANDARD=17
      ]
    end

    # From upstream build instructions:
    # "Note: Sysdig's build can get confused with GNU make's parallel job option (-j)."
    # https://github.com/draios/sysdig/wiki/How-to-Install-Sysdig-from-the-Source-Code#linux-and-osx
    ENV.deparallelize if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
