class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  url "https://github.com/getdnsapi/stubby/archive/v0.4.0.tar.gz"
  sha256 "8e6a4ba76f04b23612d58813c4998141b0cc6194432d87f8653f3ba5cf64152a"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "98de227b643cc50357f442dda39ba673c9bdba8f6b5977c6ee0f519ce0560036"
    sha256 arm64_big_sur:  "aacda92701ecc4c275bfe6eb5ede29a6f07f6d0d85701f293146880437f448f8"
    sha256 monterey:       "e3f52352894e8ed61a7166b2e3fd6fbf184264326f07615f32b450df8f162a94"
    sha256 big_sur:        "435174729967fbf5bb4dc87a8e2ef440f6cec7e56c46a5373dfe6f5a6a6ec96c"
    sha256 catalina:       "df3b7e64116093724ab01d7a6f3abee725e9ffebfd030a1255d9f6c8467101f2"
    sha256 mojave:         "21530780a842976f9dbd45777c85900b841e15a063ab522d5c8d30f4bba74eec"
    sha256 x86_64_linux:   "9e714d6c7b77449a65f7185ea9a86489a8b9019950ec11160987d5e9fa848b7a"
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
        - address_data: 145.100.185.15
        - address_data: 145.100.185.16
        - address_data: 185.49.141.37
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 145.100.185.15", output

    fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.yml"
    end
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end
