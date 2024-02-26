class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/draios/sysdig/archive/refs/tags/0.35.2.tar.gz"
    sha256 "9a9246c428964b5ce67941c0c7055044a6e590735f78d17d89c175c319b02a9f"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/refs/tags/0.14.2.tar.gz"
      sha256 "b4ae7bbf3ad031deee4a808145f9fd64b71c537406cc5a92f512823b2e52cdd5"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "1c5577677aa68a25c6fafdadafc0917c54285e7d665747af96ee56083a8138bd"
    sha256                               arm64_ventura:  "ac0496564af42b2183f121cc9c4c2b3ca701433758699a300c79ffd6fcec92a9"
    sha256                               arm64_monterey: "7cd1cac8ead46c3f15e71bf570f8d765fe1d63ff21dfae2a7bb061e02bb22e4b"
    sha256                               sonoma:         "5132a18568f15b114c024b1becae41857a049586b0a57888b374cde57742b925"
    sha256                               ventura:        "d3b42607f14ce7b5e2b0a54f2493ef5a931d8d30370df40968d1d9ec8c61447e"
    sha256                               monterey:       "17c3bfbd69d6d96d9c322100f23d71cf018d2704ead5b675be9efdd59dbade94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3101ef69bcd2501412f77037480c2d20704fdd01f89d5e7d2db47c7dc7459482"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "valijson" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "abseil"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "openssl@3"
    depends_on "protobuf"
    depends_on "zstd"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # fix `libzstd.so.1: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DUSE_BUNDLED_TINYDIR=ON
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
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
