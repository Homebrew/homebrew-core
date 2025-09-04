class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.3.34/buildbox-1.3.34.tar.gz"
  sha256 "92a973a86cb7ae5d234ee1d3a386b881ed7f874c7811ac4fb10cafb1a61de9bf"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "50e028dddd9fbf669bc289391ba1b022a1392657b71722fcef1a38a2df0b71af"
    sha256 arm64_sonoma:  "d1c8cbe087d2e238e723f8d182c31ceb85841fbe17ef93dd53ef6f9a2ac61ebe"
    sha256 sonoma:        "d9ad7b326f9477ad4bd9b2eb61ee0762821108acbb7950600331c8934a558f5c"
    sha256 arm64_linux:   "b42956e14792822a79c9f1fed0c82a25ec97208356f3678874326b6f552c3f52"
    sha256 x86_64_linux:  "fd4a6a1448a931506625da7737768d4f9bdb2610daeb3c2b1c9530848c1cbc25"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gflags"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "util-linux"
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
