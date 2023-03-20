class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.4.1.tar.gz"
  sha256 "4203c30221fdb2890b76e474f1f93119ed9b26d0fafd9ceb4298ddbf5be37c80"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a42a7d44eb1173114a0fa36aab735028e1c7bf1ee35ff2692ca5318ffb3fb9da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf3cd9cb4678b5ae78a9af091c1e780866de0ed26d555d03fc509c8b3c3531a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aa8cc797db19e16d873cb6439b55d0d168c80263bb66ef444daf7b435635075"
    sha256 cellar: :any_skip_relocation, ventura:        "74a4b2bd9f7595d716196835481128db0a55df89311f7c225d88b8bf76fce439"
    sha256 cellar: :any_skip_relocation, monterey:       "07d15997e247413209ba588efccf936a501c20a3581cd0f33406e859c351b61d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4673ac8ca0a6cb85e97d09812309ac85b5dd9fb8217e9c03412ac9ab3198cd38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473e8126e00b7cba35e02f090a19f9ca464f61ede1173e6782dbc1b395809b5a"
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
