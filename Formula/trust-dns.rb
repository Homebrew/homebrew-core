class TrustDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "0756101c4ecd20ba5cfb3d0d1b86fe19bd28daae988004c153fe1c0a052bfb85"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/bluejekyll/trust-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9a08d010802fff7fa6a94847f816669a92265596c8506fbd810e0b2248d7c75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa0fdb12c49171ce77337e73fb2ec8b06a48e6a0cf78d7b2f77cef6395adfe59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713bfc37472d6d9fcfab685f164fd3a313f3c75f0431d75276d5a05996660250"
    sha256 cellar: :any_skip_relocation, ventura:        "f2861da740e151a590f6e6042973302b9eb33830c0e0221496cfbe9582a5202d"
    sha256 cellar: :any_skip_relocation, monterey:       "e2028776dc3f0710aa7f37e40b5ae9d77f61dd63adfb4e076d96870d8d563453"
    sha256 cellar: :any_skip_relocation, big_sur:        "27cadb40add7948af20d07e7f89ffd34d72fd2fbd2584469e9558f3a94565fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b521af6e9575530584db481b3cf0a225b1d5844b710eaed2652f3202519e73f"
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
