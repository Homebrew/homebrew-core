class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  url "https://github.com/getdnsapi/stubby/archive/v0.4.3.tar.gz"
  sha256 "99291ab4f09bce3743000ed3ecbf58961648a35ca955889f1c41d36810cc4463"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  bottle do
    sha256 arm64_monterey: "9505f36ee4654adb527badc196224a2ea8969b0ed984b6e06732ef5c25571dce"
    sha256 arm64_big_sur:  "b2492e874a5dc3c235cde5dff8eb7c6e10dfb3eb52bcb12d86cc36fc8865ce92"
    sha256 ventura:        "5017e46ff77e7233c6514c99c21867af459cad30231aca16bd6311bdddb7b32b"
    sha256 monterey:       "bd4eadc1f1ffd5675c17c038ffc02202cfc024e3cb1da5ae27b67bb98479b5ea"
    sha256 big_sur:        "47c88d9d9bfac6b2cff05fad0f9a94883e4dfe7f7eacfad5c32ed6a425038478"
    sha256 x86_64_linux:   "7dd5aef38ee748eb4ea4fd8b29cda8f67becb8a2679932f0126b5a443709e23d"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "getdns"
  depends_on "libyaml"

  on_linux do
    depends_on "bind" => :test
  end

  def install
    system "cmake", "-DCMAKE_INSTALL_RUNSTATEDIR=#{HOMEBREW_PREFIX}/var/run/", \
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{HOMEBREW_PREFIX}/etc", ".", *std_cmake_args
    system "make", "install"
  end

  service do
    run [opt_bin/"stubby", "-C", etc/"stubby/stubby.yml"]
    keep_alive true
    run_type :immediate
  end

  test do
    assert_predicate etc/"stubby/stubby.yml", :exist?
    (testpath/"stubby_test.yml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 8.8.8.8", output

    fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.yml"
    end
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end
