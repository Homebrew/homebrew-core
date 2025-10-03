class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "79f1692d5ee588fb3bfdb7d4af51e4fa3a65f115d1102493e9aa788b3225ca97"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ec9fe654358fb04809a4a11b8912b9b4f6b9e791391abee1496737ca3b00d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d7493797a71e04c7e08ea549f9727cb61830e4dda87545e24d25f049127bbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32da3a1bc6da7621d1e63da5f3cb4c62d6da0e85d25dbec8f51f9155717c3d66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4793307c69ff0a43d277c2f952c536699ce1bba6479b9bdecfb49a4ed4814943"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1fb508390347136f31bcf86698f41d3f17ace1c8de346961638ed2e3908e03"
    sha256 cellar: :any_skip_relocation, ventura:       "a553a10ab6698defdf5d8dce0c9817f381cae11ced8c95dff2bc7b9422e7f944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7672b026043c6876eab7addd25a323139e15b007421286618482e48501138f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80392e5f5fc08199e1ec8fc51ba619ed0f62ceb4d9f764851af6c4e868a5dc29"
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
