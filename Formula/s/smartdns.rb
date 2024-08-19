class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "1c8de7906a789c3ec7e593cdc3803131508058429ea4e8f59d1759bf06494b0c"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0434cbbbb353c62bff0ff3fbf45842bb103aaf217b7d0eb7c2f47e153009caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41065f30094d510f4c65d44a049cfa4175bc399d2b7cccbb4761694573e0ac31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d106d7203a975b1340d2fcc10a35ab3b02622a2eb1e05c6106839f297fe03d99"
    sha256 cellar: :any_skip_relocation, sonoma:         "73eda41bc9b9f3437660faf7da16e56e746f2702c2c0e9e79664707f026db39f"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce77bb618a3df1e81f73c052a714fbaf6eb1130bb47012b4cdfd61085caa233"
    sha256 cellar: :any_skip_relocation, monterey:       "97117838f6b5a162c9b68dec536838856209ede05e629af592995157fa7af8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd2868d02f5739680b3d4f9b48a33a53b6667f8a2d136a2c0d1e8cda13fffcb8"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

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
