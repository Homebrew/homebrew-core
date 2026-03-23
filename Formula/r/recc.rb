class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.4.1/buildbox-1.4.1.tar.gz"
  sha256 "3463e6ed7100dc8ae601cfa38badc3fd9e771873980defc5a583fd8d251f9118"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "1394f89351299f5dfef34ff3fe7f7a7148695b5bcf509dd9018a1722131b1fc2"
    sha256 arm64_sequoia: "7d28850e12535c33493ad4fd73decc1f1b31d50f74a4c6bbeabc94325fa827fb"
    sha256 arm64_sonoma:  "a8a5427d5f4cb4c6a13f8d155759ac1e9d49ce8b37d1f608a439dc4cc24bca0e"
    sha256 sonoma:        "e198d4887ff661ba147010aefe39940f340b34efd76ab330cdc26a118d4e011b"
    sha256 arm64_linux:   "cad7589f759e4f3f8352aac0c32e2aff968daa8ae73b05bfaba07832ae04af2e"
    sha256 x86_64_linux:  "f2406374498c07c6a31e8a3a12f9b9160401eb3b9c09f6b9885c1ba7e6ffa121"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "glog"
  depends_on "grpc"
  depends_on macos: :sonoma # Needs C++20 features not in Ventura
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "curl"

  on_macos do
    depends_on "gflags"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    buildbox_cmake_args = %W[
      -DCASD=ON
      -DCASD_BUILD_BENCHMARK=OFF
      -DCASDOWNLOAD=OFF
      -DCASUPLOAD=OFF
      -DFUSE=OFF
      -DLOGSTREAMRECEIVER=OFF
      -DLOGSTREAMTAIL=OFF
      -DOUTPUTSTREAMER=OFF
      -DRECC=ON
      -DREXPLORER=OFF
      -DRUMBA=OFF
      -DRUN_BUBBLEWRAP=OFF
      -DRUN_HOSTTOOLS=ON
      -DRUN_OCI=OFF
      -DRUN_USERCHROOT=OFF
      -DTREXE=OFF
      -DWORKER=OFF
      -DRECC_CONFIG_PREFIX_DIR=#{etc}
    ]
    system "cmake", "-S", ".", "-B", "build", *buildbox_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    makefile_args = %W[
      RECC=#{opt_bin}/recc
      RECC_CONFIG_PREFIX=#{etc}
      RECC_SERVER=unix://#{var}/recc/casd/casd.sock
      RECC_INSTANCE=recc-server
      RECC_REMOTE_PLATFORM_ISA=#{Hardware::CPU.arch}
      RECC_REMOTE_PLATFORM_OSFamily=#{OS.kernel_name.downcase}
      RECC_REMOTE_PLATFORM_OSRelease=#{OS.kernel_version}
    ]
    system "make", "-f", "scripts/wrapper-templates/Makefile", *makefile_args
    etc.install "recc.conf"
    bin.install "recc-cc"
    bin.install "recc-c++"

    bin.install "scripts/wrapper-templates/casd-helper" => "recc-server"
  end

  service do
    run [opt_bin/"recc-server", "--local-server-instance", "recc-server", "#{var}/recc/casd"]
    keep_alive true
    working_dir var/"recc"
    log_path var/"log/recc-server.log"
    error_log_path var/"log/recc-server-error.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      To launch a compiler with recc, set the following variables:
        CC=#{opt_bin}/recc-cc
        CXX=#{opt_bin}/recc-c++
    EOS
  end

  test do
    # Start recc server
    recc_cache_dir = testpath/"recc_cache"
    recc_cache_dir.mkdir
    recc_casd_pid = spawn bin/"recc-server", "--local-server-instance", "recc-server", recc_cache_dir

    # Create a source file to test caching
    test_file = testpath/"test.c"
    test_file.write <<~C
      int main() {}
    C

    # Wait for the server to start
    sleep 2 unless (recc_cache_dir/"casd.sock").exist?

    # Override default values of server and log_level
    ENV["RECC_SERVER"] = "unix://#{recc_cache_dir}/casd.sock"
    ENV["RECC_LOG_LEVEL"] = "info"
    recc_test=[bin/"recc-cc", "-c", test_file]

    # Compile the test file twice. The second run should get a cache hit
    system(*recc_test)
    output = shell_output("#{recc_test.join(" ")} 2>&1")
    assert_match "Action Cache hit", output

    # Stop the server
    Process.kill("TERM", recc_casd_pid)
  end
end
