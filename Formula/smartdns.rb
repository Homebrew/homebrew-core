class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.3.1.tar.gz"
  sha256 "3a11e1b1c6ffc33d1120b6cec516d19a90375be283c114771cf950e2b364215d"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14394d51aae8f725e863769cc7221329bc64101739ceab7b7f6ccb5ca16d0e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "462c3b38e85097bf42fc4f221567aeac20edcc2e4ee3cb8bd68f5bc3824dd7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fa8802fff836c40ec4a3676cf79e83a6fdec8f8c978f08fbced82639b4c14a0"
    sha256 cellar: :any_skip_relocation, ventura:        "812a2a5a8bc5ec82b8135a6b3407daaa81a2a6ad99f1477387e719ae08ad1e98"
    sha256 cellar: :any_skip_relocation, monterey:       "81e35eebe5022e76d91c01e438c7c0ba37ef6c68b33a648cfdde029058c3da51"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c9b5cdd7a17e0a6f34d38723ba89a42c3ea2a5284a793e6e947117cd2f8399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a31c85825622612824e49b6eb28047359f1310fc89b4c599b412f477833d1a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", *std_cargo_args
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
