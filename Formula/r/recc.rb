class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.2.21/buildbox-1.2.21.tar.gz"
  sha256 "7ac8e96ae9c614659b9f16a988a89609bf9c0c5413241f9912f2d0d330100997"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "glog"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gflags"
  end

  on_linux do
    depends_on "pkg-config" => :build
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

    %w[cc c++ gcc g++ clang clang++].each do |compiler|
      (bin/"recc-#{compiler}").write <<~EOS
        #!/usr/bin/env sh

        #{bin}/recc $(command -v #{compiler}) "$@"
      EOS
    end

    # Generate recc-server start helper script
    (bin/"recc-server").write <<~EOS
      #!/usr/bin/env sh

      # Get current soft limit for open files
      current_limit=$(ulimit -Sn)

      REQUIRED_FILES_LIMIT=384
      # Check if the current limit is less than REQUIRED_FILES_LIMIT
      if [ "$current_limit" -lt ${REQUIRED_FILES_LIMIT} ]; then
        ulimit -Sn ${REQUIRED_FILES_LIMIT}
      fi

      # Run buildbox-casd as recc-server
      #{bin}/buildbox-casd \
        --local-server-instance=recc-server \
        ${1:-#{var}/recc/casd}
    EOS

    # Generate recc.conf
    (buildpath/"recc.conf").write <<~EOS
      ##
      # For the list of configuration parameters please visit:
      #   https://buildgrid.gitlab.io/recc/configuration-variables.html
      #
      # The configuration file settings use lowercase letters without the RECC_ prefix
      # By default recc reads the configuration options from the following places,
      # applying settings bottom-up, with 1 being the last applied configuration.
      # If an option is set in multiple places, the one higher on this list will be the
      # effective one
      #
      # 1. Environment variables
      # 2. ${cwd}/recc/recc.conf
      # 3. {$RECC_CONFIG_DIRECTORY}/recc.conf
      # 4. ~/.recc/recc.conf
      # 5. #{etc}/recc.conf
      ##

      # Protocol version used for communicating with the REAPI server
      reapi_version=2.2

      # The URI of the server
      server=unix://#{var}/recc/casd/casd.sock
      # Instance name provided by the server
      instance=recc-server

      # Use cache-only mode, build anything not available in the cache locally
      cache_only=1
      # Upload results from the local builds to cache
      cache_upload_local_build=1
      # Upload failed results from the local builds to cache
      cache_upload_failed_build=1

      # Enable for link commands
      link=1
      # Use cache-only mode for link commands
      link_cache_only=1

      # Report all entries returned by the dependency command, even if they are absolute paths
      deps_global_paths=1
      # Do not rewrite absolute paths to be relative.
      no_path_rewrite=1

      # Do not retry
      retry_limit=0

      # Platform properties
      REMOTE_PLATFORM_OS=#{OS.mac? ? "macos" : OS.kernel_name.downcase}
      REMOTE_PLATFORM_ISA=#{Hardware::CPU.arch}
    EOS
    etc.install "recc.conf"
  end

  service do
    run [opt_bin/"recc-server"]
    keep_alive true
    working_dir var/"recc"
    log_path var/"log/recc-server.log"
    error_log_path var/"log/recc-server-error.log"
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
    recc_casd_pid = spawn bin/"recc-server", recc_cache_dir

    # Create a source file to test caching
    test_file = testpath/"test.c"
    test_file.write <<~EOS
      int main() {}
    EOS

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
