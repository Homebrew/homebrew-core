class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.4.6/buildbox-1.4.6.tar.gz"
  sha256 "22a3862356e8384db624d4872b91e9f399920d077554e1d41a6bb8a6bcf094a2"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "581dbc8fe57e051351f585b46e064faae07b7b31aecdf4008c890e9c3501d980"
    sha256 arm64_sequoia: "5cacec2cfcc0b242dd4457f8cec43528ddf1fc1a9669460896e242963a82bcec"
    sha256 arm64_sonoma:  "13f1c047d39c5f73eccde403fbc499a10befb88f192fb3c44fbc1eab7aafcae3"
    sha256 sonoma:        "2b4a90817d318eebb8cb802a2d8b718e2cb790bc8a453c14f587b04d32bfad3a"
    sha256 arm64_linux:   "5c06d2fa977282f94d3e7efa09aca5a19661b25d36a866debb8d0eb629ed0778"
    sha256 x86_64_linux:  "38edef34d28974f47d03f664349d5c2b47da338e7fc869947e6a9cf94ed40baf"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "curl"

  on_macos do
    depends_on macos: :sonoma # Needs C++20 features not in Ventura
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
