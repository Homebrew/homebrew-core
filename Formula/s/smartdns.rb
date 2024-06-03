class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "7bd628e39cc9c055eb885a84c7b329cb3651f04bea524566fb15420a8c548f96"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e12d81d2b060e9ecb99573589d87ccdbbc12ff0b0f027c4c567d3002717940e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efda8dabea45e1b9f5ca96e8a103863fd2b7cd03e443a590868072aaa390c757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc88adb3fa0ce6d173c3cbab678191863e83f76d288eb10da2787b231b73d0f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c2ca304f2bb9f25a38c397ae3626a96d32af98a95ad6147b5c8da6589c7571b"
    sha256 cellar: :any_skip_relocation, ventura:        "621ef1cbace30d6c3cfb6665a18a14dec74acb871682e0632253d8074e3e87bb"
    sha256 cellar: :any_skip_relocation, monterey:       "d3523087a1c17c1bb7b542bfff74500d352fe004e3188ce3c6a008469a2594f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd5afa27cc89a709584395f834cdaac6b227cb66a86dbd14fe5ffecd92c2e480"
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
