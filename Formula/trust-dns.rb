class TrustDns < Formula
  desc "Rust based DNS client, server, and Resolver"
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.21.0-alpha.2.tar.gz"
  sha256 "c763115072f92594d51f8179c7a7e1c554047e59681dd86e1934cbad15c46596"
  license "MIT"

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    %w[util bin].each do |dir|
      cd(dir) { system "cargo", "install", "--all-features", *std_cargo_args }
    end
  end

  plist_options startup: true

  service do
    run [opt_sbin/"named", "-c", etc/"named.toml"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"named.txt").write "1233"
    (testpath/"named.toml").write <<~EOS
      listen_addrs_ipv4 = ["127.0.0.1"]
      listen_port = #{port}
      [[zones]]
      ## zone: this is the ORIGIN of the zone, aka the base name, '.' is implied on the end
      ##  specifying something other than '.' here, will restrict this forwarder to only queries
      ##  where the search name is a subzone of the name, e.g. if zone is "example.com.", then
      ##  queries for "www.example.com" or "example.com" would be forwarded.
      zone = "."
      ## zone_type: Primary, Secondary, Hint, Forward
      zone_type = "Forward"
      ## remember the port, defaults: 53 for Udp & Tcp, 853 for Tls and 443 for Https.
      ##   Tls and/or Https require features dns-over-tls and/or dns-over-https
      stores = { type = "forward", name_servers = [{ socket_addr = "8.8.8.8:53", protocol = "udp", trust_nx_responses = false },
                                                  { socket_addr = "8.8.8.8:53", protocol = "tcp", trust_nx_responses = false }] }
    EOS

    fork do
      exec bin/"named", "-c#{testpath}/named.toml"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    ip = "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
    assert_match(/example\.com\.\t\t\d+\tIN\tA\t#{ip}\n/, output)
  end
end
