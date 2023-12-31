class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.7.1.tar.gz"
  sha256 "4b459bd7790a6806f89c744906265cbc9f87713aa5ca991d3d45edf11ac82b08"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d9809ac6d893caa65c7c0c06dd3b5555becbd825d6c5359279dae4e1e604198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9e9e572815847395df3c31b71aa7490ae9c537ad8cc335a04130a7143b4469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0af0d9e2a22943bb0aefca106a46d311d392a0c7d0a504aee21c17d6b902c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "74ce0a660f1669394f8f6298b7246d7ab46680f281616944952d0310c84b107d"
    sha256 cellar: :any_skip_relocation, ventura:        "777298535773c0bab51ef019b077cc60f4ccd3d9d0f67655099cabb3fa6152ff"
    sha256 cellar: :any_skip_relocation, monterey:       "dc8254e4c5678dc93206777ccbfb59d353d1dafd5db5bed730287366c0c0fd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5692aff003b14211d2bbcaf532e17add89c1c705ca1c451336dbe96d77451379"
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
