class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.4.28/buildbox-1.4.28.tar.gz"
  sha256 "ead444ae10887cbb7ee9e650a5c606955370e38dcefdc25ffee79db9146ae203"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "2d29fbfa3518f7bbd2e5708a2c2beb17392a01403ae9933969e8398cbca27619"
    sha256 arm64_tahoe:       "2ea047e0b18d758e35e734bf9b4354deab220b12aab6af822353ae7b3ad87e0f"
    sha256 arm64_sequoia:     "6ea65e39a181b661d451ef086f45823d5e494d9f4971535ea0db36b8ffb01459"
    sha256 arm64_linux:       "48c571427eaabd5223feca091487b3c6636a5fcee0cc7b7cb2dbdbd200f2fcad"
    sha256 x86_64_linux:      "2d156be5ade35f5463b23fbecb88ec3c695bec5e0026a273dcb59605bf8c5071"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "grpc"
  depends_on "openssl@4"
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
