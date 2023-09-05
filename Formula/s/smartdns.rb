class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.6.4.tar.gz"
  sha256 "c835cc2bd3190f9b92cdc1c0b209847a3fe90a4780e81045986f753454558112"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc83de001b87df47f8ada3353c34d221d5734c74c1f54fbbbd9443142b54583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef9d5aecbf5cceb1e100a17bbe4bd3ba9d57a17a3f7bc2e5d6dd2892bdbb3be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7345c01ddc55271f02775cf9249041d79518d5cda190aa09edcf95f8463a30d7"
    sha256 cellar: :any_skip_relocation, ventura:        "cb7770a719c1daa9104499e0e214ca9816b8e5e306264eb0bdf6000d09dac7ef"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf897b00cf29a95d7b7f24a9cb461e80757d8cf44db30d0948ce2331b06f2f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "caa696761c89cb5a8fd7ccfd8930190f48064edfba91584a26e861f2d3ed0825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b76824a54e9b5f86cc5f7404ff16b5091e6c476030d0a5d902a8c8e6bbf5e45"
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
