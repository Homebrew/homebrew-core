class TrustDns < Formula
  desc "Rust based DNS client, server, and Resolver"
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "1766f59ea28e1c1289fcd370d455ae73416814035bad1de313528391cbf8454a"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    %w[util bin].each do |dir|
      system "cargo", "install", "--all-features", *std_cargo_args(path: dir)
    end
  end

  plist_options startup: true

  service do
    run [opt_bin/"named", "-c", etc/"named.toml"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"named.txt").write "1233"
    (testpath/"named.toml").write <<~EOS
      listen_addrs_ipv4 = ["127.0.0.1"]
      listen_port = #{port}
      [[zones]]
      zone = "."
      zone_type = "Forward"
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
