class TrustDns < Formula
  desc "A Rust based DNS client, server, and resolver "
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "1766f59ea28e1c1289fcd370d455ae73416814035bad1de313528391cbf8454a"
  license "MIT"
  
  
  depends_on "rust" => :build
  
  uses_from_macos "zlib"
  
  def install
    %w[util bin].each do |dir|
      cd(dir) { system "cargo", "install", "--all-features", *std_cargo_args }
    end
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/named</string>
            <string>-c</string>
            <string>#{etc}/named.toml</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/trust-dns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/trust-dns.log</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork do
      (testpath/"named.toml").write <<~EOS
      listen_addrs_ipv4 = ["127.0.0.1"]
      listen_port = 53

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
      exec bin/"named", "-p #{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
    ip = /\A#{block}\.#{block}\.#{block}\.#{block}\z/
    assert_match(/example\.com\.\t\t0\tIN\tA\t#{ip}\n/, output)
  end
end
