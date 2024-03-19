class Rathole < Formula
  desc "Reverse proxy for NAT traversal"
  homepage "https://github.com/rapiz1/rathole"
  url "https://github.com/rapiz1/rathole/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c8698dc507c4c2f7e0032be24cac42dd6656ac1c52269875d17957001aa2de41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c50a599d6af659f38e664edc68a64e310d4644e393cd6bbb3305a30742d9a359"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17c4060ee9ee8843616218c57079814ffab9e8d6985ccc433da9b5d4796d1693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70de936393eb4685c9b4e5cb525ede6aa057622555fb17bbcf8eb9e2141bc175"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c511f72f60fc490db1e891416a0b279e7d5ade7984bd70d505e86b4f8859613"
    sha256 cellar: :any_skip_relocation, ventura:        "acbf4897dd9560e0f0e9597f020b9b434e349edb5b9ec70251fa08a237bcf923"
    sha256 cellar: :any_skip_relocation, monterey:       "87be8e479e7d36ca01aa450fd7b6f5e820054ade4a06b43ca967f0828eddee17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9258fe59a3e086fa53c499d8a086c31fe7a779b8cd0426f85d53b6124916ce02"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"rathole", "#{etc}/rathole/rathole.toml"]
    keep_alive true
    log_path var/"log/rathole.log"
    error_log_path var/"log/rathole.log"
  end

  test do
    bind_port = free_port
    service_port = free_port

    (testpath/"rathole.toml").write <<~EOS
      [server]
      bind_addr = "127.0.0.1:#{bind_port}"#{" "}
      default_token = "1234"#{" "}

      [server.services.foo]
      bind_addr = "127.0.0.1:#{service_port}"
    EOS

    read, write = IO.pipe
    fork do
      exec bin/"rathole", "-s", "#{testpath}/rathole.toml", out: write
    end
    sleep 5

    output = read.gets
    assert_match(/Listening at 127.0.0.1:#{bind_port}/i, output)

    assert_match(/Build Version:\s*#{version}/, shell_output("#{bin}/rathole --version"))
  end
end
