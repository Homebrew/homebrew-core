class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.6.5.tar.gz"
  sha256 "eabb03adc91a5cc985c4fbbcb64dfaa5bd475051060d6c3540dfd03c8d379f11"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b1fdcb11703b1103631f598aae02d429e473097db99445c01f60cb34df97752"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e6477575b7103d0076e8bd989616d8e56e858c10c364a7dd24ce55a045ff320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b0c035b3205fb4eaecef2d974b53a29bfb16efd11ada3483e045a4ef0316b26"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb6b27ce185b5b4e8bf7452ae6ef84b96dbac9806f625088507a791860425a67"
    sha256 cellar: :any_skip_relocation, ventura:        "3e31da7ba947d3bde45b732d970ab6734673f21b792ef9f22b9015cbd407669a"
    sha256 cellar: :any_skip_relocation, monterey:       "85ef0e970f65dfd88b8bbaf4c0bdc1860a18ce7fc45909b4d3070b5771fe20b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f41cd36a833ae2f99432843be97ec30bf29662058fad32984f080954d4dcc7"
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
