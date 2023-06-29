class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.6.2.tar.gz"
  sha256 "deef7735a9557efe8aada799fa0bc2bfff6d24c2e6d704644ee5a00f879e8294"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "626ba4152804034bc21a18091a585790110195d1eb0c399ad174d9a21ed7aa1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "144291efce470d8450fdfb17ce8bab77fe5cd45aff6becb12b557b3eaa1112fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea2ef8dd9d90fc592acee7fe41a4c29c55e9318f7100036f5b445be0f355b345"
    sha256 cellar: :any_skip_relocation, ventura:        "4b8b826ba53dcb835874ee8c4f2b92f5dbe5b6cbdfaf6bc51d2ee2a9e746f369"
    sha256 cellar: :any_skip_relocation, monterey:       "58e76efa63b2e22f11d6da9f7e4c0088bbbc39e48a8e5c00f3bae83513837473"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef684d7f0f19fbedb4ba2edb957cb99f5004c872cd835050906c620bba64204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a332824c5c71c5d09278ffd89999f3711abc50bccde2dd05c6e9ec2d96d27c"
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
