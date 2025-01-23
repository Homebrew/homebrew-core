class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 14

  stable do
    url "https://github.com/draios/sysdig/archive/refs/tags/0.38.1.tar.gz"
    sha256 "68085ea118a4209dbde8f1b75584f9f84610b5856e507ffb0703d8add6331132"

    # Update to value of FALCOSECURITY_LIBS_VERSION with
    # VERSION=#{version} && curl -fsSL https://raw.githubusercontent.com/draios/sysdig/$VERSION/cmake/modules/falcosecurity-libs.cmake | grep -o 'set(FALCOSECURITY_LIBS_VERSION "[0-9.]*")' | awk -F'"' '{print $2}'
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/refs/tags/0.17.2.tar.gz"
      sha256 "5c4f0c987272b7d5236f6ab2bbe3906ffdaf76b59817b63cf90cc8c387ab5b15"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "dec6d83e133c6f1179e7a4f43a6afdf894fb4d68db57f05e4189c845de9bb16e"
    sha256                               arm64_sonoma:  "14b630015ceb9318f8d5dc4ad64d67f42c5f34cdcb60bdfe40a4c65615dfe071"
    sha256                               arm64_ventura: "660e66a065808d1ef86e5a057bb31c95ce261605a59dbc3686cc1f7bef3a437e"
    sha256                               sonoma:        "f4d477945faeb8aa30c70811d8365395f85cf41f0bf004ce7f268cea39ec0083"
    sha256                               ventura:       "50cbb48f40abd7ac76f45c671034126b88ef665d7537410c7283ccfaea769adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e485410f09083bbb28c9e656e63ffd0345e478ca0df2cec9d75649f2a17b75e4"
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
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "ncurses" # for `newterm` function
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
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
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args += ["-DBUILD_DRIVER=OFF", "-DBUILD_LIBSCAP_MODERN_BPF=OFF"] if OS.linux?

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
