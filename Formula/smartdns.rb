class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.4.1.tar.gz"
  sha256 "4203c30221fdb2890b76e474f1f93119ed9b26d0fafd9ceb4298ddbf5be37c80"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1468c56e0a1a9cab6dfdead21d5cb2f75bef17a3069add01b1782533ca144e71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3981003b75e5903e14eb152011d2ba986a8955d3188a072c6fc2556cd7a13d1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b5be5bda9e89986e06a822db7f02fcb3f9c850270bc8ce3092a418b7a2625e2"
    sha256 cellar: :any_skip_relocation, ventura:        "4ac27d4a785c22be97aba1074791523cf421f51e062082b840bae710330cd608"
    sha256 cellar: :any_skip_relocation, monterey:       "f8da3e6987d9b105f399bccbaffc4fca853f8f03c1c59262488fe0604d917cea"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6bfc83e1d21cb51d21b8f7408bc6eea3b4abed2943413837a8e6f9faba60bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c9cf520cc12a73159f0bc1f259c89db1cdf00e1cb6bd777f10ccebeea9da80"
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
