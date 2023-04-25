class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.6.0.tar.gz"
  sha256 "5850c04c9ba279c1dddd66b9406cc9ba7820661eee8b71c7e9a3424c2edbe1ba"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd7ed2dc1de2a455abfe3d3bd117dc49a06c2eb43d039395c73ff261ae88066c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d198db3ca4ee0080374efe7450988601c4460710f2fa4f2ea94d5bd6627ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d21e80affe24d13646e7449ac5f9651f0c6f138dd0074c42e57b011b06439b4c"
    sha256 cellar: :any_skip_relocation, ventura:        "adce48f8b2d4c7aa588c62fad0aef7baa04c55d9b9015f0c58ef64b377034548"
    sha256 cellar: :any_skip_relocation, monterey:       "52dc1b8da0eb1d08f7355a5a3e71b3a1e9bc56884e0c81f4fbcdead581db1a97"
    sha256 cellar: :any_skip_relocation, big_sur:        "876004162213ca2c2ec90731c1230c73c4b0bb759b5fd1dffd84e4d91a3153c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c13fa1769e2863fc1688c7bf2510ebba6f4f1fa09e4374317a604383f032e3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", "--features", "homebrew", *std_cargo_args
    sbin.install bin/"smartdns"
    pkgetc.install "etc/smartdns/smartdns.conf"
  end

  service do
    run [opt_sbin/"smartdns", "run", "-c", etc/"smartdns/smartdns.conf"]
    keep_alive true
    require_root true
  end

  test do
    port = free_port

    (testpath/"smartdns.conf").write <<~EOS
      bind 127.0.0.1:#{port}
      server 8.8.8.8
      local-ttl 3
      address /example.com/1.2.3.4
    EOS
    fork do
      exec sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
