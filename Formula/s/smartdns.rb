class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "4ffd4021d751dcdd572df9dffd2f2b554c12192baa9cdb93a604bace53644bb4"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cca8fd83bf07a8acdc6376bc063ba43a1f8fcbc9307555cbf101d37bd941deb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762c01c1b00e40bbd3ed4a841fdc7ad8ba9a0d2dc098172e25be6ba1ead9f5cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bac5030e4ae39efea04295fd4debab619990d48595d9dea45fcc6a62c7a27f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb6c57ce62cbc27fc4692c82e5a7e664ec3a900620792f844fc77881f6db1693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a5fab40ff8bd77da35573c3139ef68d955af05e7fb8926b362fa61e601e858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7b6a4d74488b51e08444c54a09a6cd24dcc14e3335f1aac18b19af8ee9e379"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3" => :build # cargo patch
    depends_on "pkgconf" => :build # cargo patch
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", "--no-default-features", "--features", "homebrew", *std_cargo_args
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
    spawn sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
