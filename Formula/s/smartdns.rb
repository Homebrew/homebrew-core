class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "369dc4e6ff15fac7065d7c427b8a29d1d45be9487706da1b293b400cffb7be5f"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48eae676ab4828a2d2f8128c5f1bf697704c32bc452fc1207116579395d96850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a75dce6caa8b414cc8be290b1ca68af4b96877c78fc857b35fb9497320b0cf47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccf74da62958e3ba61d576972e684a932f40a76dfc280612f91c0ac390a46b77"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ae8bc9241510d1fd4caa7cd31f02f68fdc780d2bc36c6f4d681ddd00db1dfc"
    sha256 cellar: :any_skip_relocation, ventura:       "5bdd22f6a86e7b6a51dd40c9a024bc0e079eb67654ebf0096c7057d707be7e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e59dab119230913b20b69cd7bd9f5693a7e601cead3f71a3319adc98df1778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "308c0b51d6d4778814b5f6cefd0f5bbe204317ea0c6b90d4c9af622eede614e9"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3" => :build # cargo patch
    depends_on "pkgconf" => :build # cargo patch
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
    spawn sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
