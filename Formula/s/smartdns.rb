class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1c358f8794ade8df976a259128372c665be81cfe04fe3256d42306da30d4b60a"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9392399a1d6d1fb453185577bd1abfe493b6f975494846f4caab139e8600b11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c6fe42ee9905ad65a38a41e5a9825ecbe4a386bb5263c96410b30a5a5fc16d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15b234a11c28e36903bc3243eba29615c21b1adbc00cbbb016cfc270a347afb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a142498d587b0691a48a4b8e7b884b9d71dfce67077e79304d56dcba6d22f857"
    sha256 cellar: :any_skip_relocation, ventura:       "d61d2640c4a06106386b45981b7a50e605f2cd033633a6149c8a4fbbe85a538a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68041e96b161dff8b6321afbe2d5d0d6cb732fb680f2feeb9d87b087d1f7979a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61db013d4f6fedaae7c0473af966eccb9f7be9e7c4610bd75ace8acf20bdaeeb"
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
