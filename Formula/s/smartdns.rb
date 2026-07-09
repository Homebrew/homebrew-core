class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "18e9f15044d9b59dfdd6559f234eac97a73335054d1b64b251274c23d1b1219c"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42234518894d332d2b6fc507d559d76245387dd11d06fb73bafda30409688872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ed79bcd9e295ea141006c22359a2b85e45f6b15567c349acbd5cee3ff2b4031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cfa49a349b573ca8d99adcace0d8d5ea1dd7088c58e0051ffa32813ae354933"
    sha256 cellar: :any_skip_relocation, sonoma:        "895d6856c5080a5d82b3c93fa1ba944df473c6922fcbf36752bee43507c82d7d"
    sha256 cellar: :any,                 arm64_linux:   "aee9ca8d68cf9f448fb320820fa8d1481d04fdd35eafdff0bd0286194a07be20"
    sha256 cellar: :any,                 x86_64_linux:  "806929455bc5a9206443ebffef0975f03187711660075cab348248910d805555"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "homebrew")
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

    (testpath/"smartdns.conf").write <<~CONF
      bind 127.0.0.1:#{port}
      server 8.8.8.8
      local-ttl 3
      address /example.com/1.2.3.4
    CONF
    spawn sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
