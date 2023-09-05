class TrustDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "258c33f0d0e6a6007afcce1dd9453b14bf4d4f074111ec4488f24be0f11645dd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/bluejekyll/trust-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bac8e1ce73f817ab96bcf8d7ba3f287908e8d9ff96ba010ac7299080c5671fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9914de2d35f8eeafb0df04a00992eb5fdf38147cb063aafda84117511ad3d285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d24296a7b53a912582bdc3872f45e8af3a9798ebca4dd99606648b222ddec21"
    sha256 cellar: :any_skip_relocation, ventura:        "422744ec62682cc9810603127ba556e451f8ff212b183b9cf144d403edbd9315"
    sha256 cellar: :any_skip_relocation, monterey:       "ed626729cc1473f3d286af7a934bcb77c4ba884c0e21784d5a5d89ef0ad0254b"
    sha256 cellar: :any_skip_relocation, big_sur:        "68a852e9a815c6f94361935b6f5d8819c68ce9100e87a4347646bf9819282dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec9b380bbcae0627faa1cabb533c59c094d61f811ab82cfb679bc44a9071d39"
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
    test_config_path = testpath/"test-data/test_configs"
    example_config = test_config_path/"example.toml"

    pid = fork do
      exec bin/"trust-dns", "-c", example_config, "-z", test_config_path, "-p", test_port.to_s
    end
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{test_port} www.example.com")
    expected = "www.example.com.	86400	IN	A	127.0.0.1"
    assert_match expected, output

    assert_match "Trust-DNS named server #{version}", shell_output("#{bin}/trust-dns --version")
  ensure
    Process.kill "SIGTERM", pid
    Process.wait pid
  end
end
