class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  url "https://github.com/getdnsapi/stubby/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "99291ab4f09bce3743000ed3ecbf58961648a35ca955889f1c41d36810cc4463"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  bottle do
    sha256 arm64_golden_gate: "53cf1ae763ad5f9b2e9f406bb3c6acb88ce57b4a9c7f23245a41caf3e78aab17"
    sha256 arm64_tahoe:       "78a752f51fc6e9bb87be7be10fde0e62b77b32a585318516f8d5a8e787b80b1e"
    sha256 arm64_sequoia:     "2e789612111c36d6f8f9a181fbf29dece851640359f2421b622852fb859c4cb5"
    sha256 arm64_linux:       "c3470c5c23c72716a6389633982ecf51c3b805dc755c0822aeb4cce62b88f8b5"
    sha256 x86_64_linux:      "0f0ed9828ada0b10bbced52fd7f2f8d9aaf1691ee6c290d2d12fc9c911f8a890"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "getdns"
  depends_on "libyaml"

  on_linux do
    depends_on "bind" => :test
  end

  allow_network_access! :test

  def install
    args = %W[
      -DCMAKE_INSTALL_RUNSTATEDIR=#{var}/run/
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
    ]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"stubby", "-C", etc/"stubby/stubby.yml"]
    keep_alive true
    run_type :immediate
  end

  test do
    assert_path_exists etc/"stubby/stubby.yml"
    (testpath/"stubby_test.yml").write <<~YAML
      resolution_type: GETDNS_RESOLUTION_STUB
      dns_transport_list:
        - GETDNS_TRANSPORT_TLS
        - GETDNS_TRANSPORT_UDP
        - GETDNS_TRANSPORT_TCP
      listen_addresses:
        - 127.0.0.1@5553
      idle_timeout: 0
      upstream_recursive_servers:
        - address_data: 8.8.8.8
        - address_data: 8.8.4.4
        - address_data: 1.1.1.1
    YAML
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 8.8.8.8", output

    spawn bin/"stubby", "-C", testpath/"stubby_test.yml"
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end
