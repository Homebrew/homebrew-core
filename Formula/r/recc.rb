class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.4.18/buildbox-1.4.18.tar.gz"
  sha256 "3749d7a8fa9db38d51f575a45214c4a0fafdde86574523ec6c460c12e7eff6e5"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6cb7074a7ce2780b5b45ad46fd84598a743bed59baf5a3c508ed043ed23bf450"
    sha256 arm64_sequoia: "47803db23f7526a82ccb9f49cda3480e619273a665728a53f7f7e066e72636b0"
    sha256 arm64_sonoma:  "5dffa616772206c5490e4dbc4e15bd581a320764504de0513b0d8934fb48efff"
    sha256 sonoma:        "76aeb3a4e9164cfc46887cd531f666a32927def56d110ae70e586ee3854176da"
    sha256 arm64_linux:   "5d1d97a640da1a6cbc1391c45c86477450487406cc615b2c5ab311a6103fc89e"
    sha256 x86_64_linux:  "805bd7918264072909d9841cbf9de9875dc387b2e8ebde6201d1ceb50207a883"
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
    (testpath/"main.c").write <<~C
      #include <stdio.h>
      int main(void) { puts("recc works"); return 0; }
    C

    # The action digest is recc's cache key, computed without any CAS server.
    ENV["RECC_VERBOSE"] = "1"
    digest_regex = %r{Action Digest: (\h+/\d+)}
    cache_key = shell_output("#{bin}/recc-cc -c main.c 2>&1")[digest_regex, 1]
    refute_nil cache_key
    assert_equal cache_key, shell_output("#{bin}/recc-cc -c main.c 2>&1")[digest_regex, 1]
    refute_equal cache_key, shell_output("#{bin}/recc-cc -c -DGREETING=1 main.c 2>&1")[digest_regex, 1]

    system bin/"recc-cc", "main.o", "-o", "main"
    assert_equal "recc works", shell_output("./main").chomp
  end
end
