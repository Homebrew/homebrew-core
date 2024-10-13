class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.2.24/buildbox-1.2.24.tar.gz"
  sha256 "098de85fa2dc25c3aff4c91d9b7482dfc5842125344e51571991b0eddecbb1c2"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "183dfd1da635da84e7b5ad05f7d2039c328ed9fafc4859840936e69bcd2c3578"
    sha256 arm64_sonoma:  "54134c21c95d54b97716380ac73aaa496850ed149fc9731634d21654deeae7dd"
    sha256 arm64_ventura: "fbbdd33b2fed59f07eb7c73bd033fa0a9788985ee26122579d0006c6a627e3d5"
    sha256 sonoma:        "89a15307fe615f1a871774776c12f37cd4c61a860fe4431ecd858bcbc939126d"
    sha256 ventura:       "c855341953276bba6a882e7755c62bda47ade2d364f322ee18efeb85eac1f166"
    sha256 x86_64_linux:  "145386d6b43da859dc86b85b830cfac10291e74428c2297915ff1f2068d8c656"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
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

    ENV["RECC_BIN"] = bin/"recc"
    system "command envsubst < scripts/wrapper-templates/recc-c++.in > recc-c++"
    system "command envsubst < scripts/wrapper-templates/recc-cc.in > recc-cc"
    bin.install "recc-c++"
    bin.install "recc-cc"

    ENV["RECC_CONFIG_PREFIX"] = "$(brew --prefix)/etc"
    ENV["RECC_CONFIG_DIRECTORY"] = "\"${RECC_CONFIG_DIRECTORY}\""
    ENV["RECC_SERVER"] = "unix://#{var}/recc/casd/casd.sock"
    ENV["RECC_INSTANCE"] = "recc-server"
    ENV["RECC_REMOTE_PLATFORM_ISA"] = Hardware::CPU.arch.to_s
    ENV["RECC_REMOTE_PLATFORM_OS"] = OS.kernel_name.downcase
    ENV["RECC_REMOTE_PLATFORM_OS_VERSION"] = OS.kernel_version.to_s
    system "command envsubst < scripts/wrapper-templates/recc.conf.in > recc.conf"
    etc.install "recc.conf"

    bin.install "scripts/wrapper-templates/casd-helper" => "recc-server"
  end

  service do
    run [opt_bin/"recc-server", "--local-server-instance", "recc-server", "#{var}/recc/casd}"]
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
    recc_casd_pid = spawn bin/"recc-server", "--local-server-instance", "recc-server", recc_cache_dir

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
