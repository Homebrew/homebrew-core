class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "34adf248c951d730ec03675c890f1238a096c9ed36373323b55a1b14d26fc215"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4844ee94d69d722063dfabf275cedb7f0ab4b873f2db78ba8058f448d925845"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd6cb8b4a6ca8944ee7e470c5f07e4bbf9ba90d68fc8c5e8231f305a961934c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "524d62114c2f1b46ada8d688a3e00e2c11ce104b545bdcea1a934e1876a1e5dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d9668ea22c8846e91f30b6c8bde473cfaadb462e8fd2a740ff11da55ca47b39"
    sha256 cellar: :any_skip_relocation, ventura:        "baf63c462ea2eb4112318a0d3faa137b3f5f0abbed71b038320cde34dda6b6c8"
    sha256 cellar: :any_skip_relocation, monterey:       "0f062d9db958568693a18819b8d8d833c98e60c70b7769bb8e3c673f5e5dcfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c910d14ae8f42cab616bb96dacb228a09690663c3e1755ac01db381a535f03ec"
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
