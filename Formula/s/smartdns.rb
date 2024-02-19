class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.7.2.tar.gz"
  sha256 "b6ca4c29166339e995a4aa52f5ace94b27fce2e38d38824c80b45f8c17463b18"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "359fb3a10ae1230d4af71765cc31276369a8a87274cf0bf9ce3f08fcfcbbecf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7b372790dc4c444f1e8122c661e712a748d958e95d8bbce43fd0ffbf07aea5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a38b0f197050ac1009dc43e0e8f41d0f2cd55fb7869f027985e4a7b5eff78df"
    sha256 cellar: :any_skip_relocation, sonoma:         "10cd376618da9a355db1095dca0ee20fc49602d609fdc8ed41edad7ca884b7df"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5f8003b1fdac57172ba7f21e31e97038b74ab686ed248e0a85f00da2dbf96a"
    sha256 cellar: :any_skip_relocation, monterey:       "15348be41e7bc6a595d30d429bbe58f51d4dd7239eff2109e0fecabeb8e18446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e051e08b02126a2189298029c67e6272e06598792d4bb32c358340413481d11"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" =>  :build # cargo patch
    depends_on "pkg-config" => :build # cargo patch
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", "patch-crate"
    system "cargo", "patch-crate"
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
