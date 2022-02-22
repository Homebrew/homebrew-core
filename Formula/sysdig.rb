class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.28.0.tar.gz"
  sha256 "817e595d501acf3fe11dc659a154aadbba848dd87ae801f5bf34a42e84979f37"
  license "Apache-2.0"
  revision 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               monterey:     "c3affa1008c1c41381e9980f4d8a6d27b85e7e4b385e6a13ebf965f5ec66c7b2"
    sha256                               big_sur:      "7983e5dfdf9148eadbf9446a0df93561bf4e9c44317c706f7103ac90a525d37e"
    sha256                               catalina:     "f55a45f24991b32e77519c8d61ca96877e4a748e537b65c3658882997cf55496"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7cb2654ce3a73546b4903677e75ad5b38a348e9307030763b229d4648bd28139"
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
  resource "homebrew-sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    args = std_cmake_args + %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
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
