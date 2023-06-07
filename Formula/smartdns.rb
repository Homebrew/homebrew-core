class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.6.1.tar.gz"
  sha256 "fb888f14bfd036dc7bfc49b2a9826126f927c4dd43390f0d4ef996d8f70b6855"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5339c000e0002e79da2b8e9d911c09527ea2685d564e99c0987b6105e9ad0eab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c4d0fec80894c158176653712082bfbc489f790805657c94dedfb9f142f9832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e782ca9ca0a7cddf0e09b8abd3b78bb50ad0b39f70f7a6f36d0265508057c98"
    sha256 cellar: :any_skip_relocation, ventura:        "657b7c198729d5c5b2ce9c818916134f87a4682bda04f32108c26ef08bafd27e"
    sha256 cellar: :any_skip_relocation, monterey:       "66e7fbe214dfc986705c5cb515e24de5585aaca45f92b309b0bbee7c21f09fbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b9905bc5d7370945bc4c5848f1f432740c51493eec67dc4c2d9b52fdccf8d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6575f6f3a444519cede38bf312a8e218e98db2b7647ef5fc7bd1e1d9b0eef3d8"
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
