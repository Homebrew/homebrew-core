class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.5.0.tar.gz"
  sha256 "19efcf9175cd83c2b6bccc45338ac6127766dd9a3cf82657bd6a9fc8a07b77d4"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43c8c3c969e3eed47f01be4c7b0bf1dbffd7ba10ad0361d2878a6887d6769534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9172b13065c6ca2602d5e2c6815e7d4d6f954db7bd3ef02c673497541304a5de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6940b6b20321a0c52f5f0f56121fecefefad73619d42cad0e5a06009979df0fb"
    sha256 cellar: :any_skip_relocation, ventura:        "728007f4c38456af42db4e856be9cab7c5b4506d89280053802551a6439eb0c8"
    sha256 cellar: :any_skip_relocation, monterey:       "73719b875f7001811195c3a597227d76b8669bdadb04525bfa663feabb9c5a46"
    sha256 cellar: :any_skip_relocation, big_sur:        "626479ed00861e1e0f3bcbebe1e00a0849449654c5edefb2f108d58c6c34ac2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7625a746a423bd287ab6b5ff28678f87e793294e43913941d69e1884cbc0ad10"
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
