class TrustDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "48debc51079b43a942f05f51dfd6d7ea900ed21f6db72e3136f100cb35263a15"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/bluejekyll/trust-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fabca7db9c4e9ebf00c2e0cc49ada98a3592f2fa9f2c75228ac975c50ae8c53e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c965b32e370d998e7afeae07785fc37d3fc26e58a0a4063c436602ac950e1987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5280c4cdddcdab6e7d658ddf21af8e52c4328f3d7e3639aa58c11315368b7feb"
    sha256 cellar: :any_skip_relocation, ventura:        "37162e844630ce06bb23edf76e0d8b292052c0e06c1cee69826d68012aec0e38"
    sha256 cellar: :any_skip_relocation, monterey:       "e4459b5c8d61f086d22f1f87529d274720d29d006e6004af4fba42a26ee27b16"
    sha256 cellar: :any_skip_relocation, big_sur:        "61fc5a09b2cc325d50a6755d548d770a862f4217e73f1a8456e67e4bd5f6e4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7607f9f4e4a599259107c7a974a8515ed30e75c8fe0b4017b76435dd0db51a32"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "tests/test-data"
  end

  test do
    test_port = free_port
    cp_r pkgshare/"test-data", testpath
    test_config_path = testpath/"test-data/named_test_configs"
    example_config = test_config_path/"example.toml"

    pid = fork do
      exec bin/"trust-dns", "-c", example_config, "-z", test_config_path, "-p", test_port.to_s
    end
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{test_port} www.example.com")
    expected = "www.example.com.	86400	IN	A	127.0.0.1"
    assert_match expected, output

    assert_match "trust-dns #{version}", shell_output("#{bin}/trust-dns --version")
  ensure
    Process.kill "SIGTERM", pid
    Process.wait pid
  end
end
