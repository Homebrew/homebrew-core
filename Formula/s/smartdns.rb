class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "67adf2fbb005e6f0a1d933b0c115bedc4b5652379c50562808d424ce9b33a1a3"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1705572a852127990d10ab2c2a9982713ec526ca65c914e13bb7f14ddb3e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2356cb9e654e8e54b0d393641be42b9135b5c933d6d27f69ce8a95274ee028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "792415b9f735397dfb5a82ae151c8b54c987d4a9351c701f2a86d32f43fc6849"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa0a725878e7413b8dd21d71f7272a623e6f4f1f23bd9847b9b34b87daf6737"
    sha256 cellar: :any_skip_relocation, ventura:       "dcfbc5f16dcfc03d5e05ae49bc276da35f6b19f4e2201e1fd6b62c2ab19d3221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36be64728cc8cca4700af1fe8610959bdf23344542e743388a302e645b19c169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22472f35408c836e9588f7145674d9ec908422289d2f7a36f37286a5dcc8bdcb"
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
