class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.3.2.tar.gz"
  sha256 "6e21d37c6c9b069166e4cf652269cbacec0db7caa7f63eb8bafd7a14f8a7f224"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfe8641e08520903f0f67be4af3f701347126aa8b19a2e4ddc4b746bb402d1aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6bfb58e2694bb495e1291152350e82ab2b1ff3bd49883bddf3c9ae5af94f4ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3691b9ba428c11470601f7d221bd3bb8582a300342945014366b0e290b4001e3"
    sha256 cellar: :any_skip_relocation, ventura:        "9b380692f3d870ba703739f6693acbab93f624387241592df782ae89d9fbec43"
    sha256 cellar: :any_skip_relocation, monterey:       "c162c736d9eaeab44f87c63c2b7f41023610f37061b39e64582f6378af2f31bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b18f7f5e1682cb88508d2e0209bf5781a951827fdaa642a84096b7b1fd22ead3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef19c0fb385ee16c63c911b145886ea64f3394d78cbe6de52a3e92fa1275ac3"
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
