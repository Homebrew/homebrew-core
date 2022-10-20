class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  url "https://github.com/getdnsapi/stubby/archive/v0.4.2.tar.gz"
  sha256 "1525934e8e6b476edc4e5668c566705e99927336db58aee20c1643517fc064ed"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  bottle do
    sha256 arm64_monterey: "8dae5616a15ae8b79386da0bd2faff4a2b55c790f13c427cce9c74b85b9d50a6"
    sha256 arm64_big_sur:  "7501e035287e7410f00b09c6a36951d0b0510085f3401687a84a62eb61da69d2"
    sha256 monterey:       "54e6f97cdc8e0d26bcf5567509f3a53661c01e773489073fb3b9cba4bd7ebe17"
    sha256 big_sur:        "59c635a262c65f3e19ee9fd8791e7686e93a14a17b3e7329971f50637c538bfb"
    sha256 catalina:       "52208414687d233e96e3938eda73feb5d8aa4e7601789db9276ff0cbc1ed791f"
    sha256 x86_64_linux:   "aedb813029fcafa50af6bdd12eb6a8299bee1d71f59a0c5d41b1b02921fbc0d6"
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
