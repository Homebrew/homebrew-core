class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "799b78fa37e50095b37ec09416a529f3f980dc8e02d0b5caef03193841531bb5"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec6df1f9d69a2079e79dec0a3a8618eeba12864d7a88c214f89d765f7a2912f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f316a8109eded1479e9e45f44e4f993075d151dfe4ab14d58a2fc298c0e8820a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d8d79cdf278a71654fdc3dffeaea87c1f628cc05c88d38d46b95593a23b41b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e5dec1f06de5cc4ca22dea3ec2814141074744d04e76722c83886999bafe02b"
    sha256 cellar: :any_skip_relocation, ventura:        "b428a2487a4b2c25c8f8871e4507835bf539ce19b40563bb9de2de95a66ae2ee"
    sha256 cellar: :any_skip_relocation, monterey:       "74c40d61ad899969020af7c0814fd20c8887ba8d6cf88c151ff34516e53f0218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27da466cf5fb88461f38a6e132e14b34e297c312a00572860f7001f1fe877a40"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" =>  :build # cargo patch
    depends_on "pkg-config" => :build # cargo patch
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "just", "install", "--no-default-features", "--features", "homebrew", *std_cargo_args
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
