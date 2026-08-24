class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "41e18e27fc8f1aa5d156877497fbc8960a4800c771cbd76ac5d221b0c203c95f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f7f84c587f8dcd4b10bb2f6d5d1d90f41d801a48a71e961ce3c0578c366a1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36253e08494b81dda36c123ff2087b5eca859cb40ede9ca24f67880d999d78ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a893cd56f7143dc605d4c16ef6e42476181a15398f9ceaa0bff4a9ebdf69f396"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b836a5514f7f2433f84fdc8a3423ffec0c9a2ce46b37280cb1c9881b016237b"
    sha256 cellar: :any,                 arm64_linux:   "386ad2610ffa0db0f447b0a275297f698a5a40e99bbea68d1079945d7d285871"
    sha256 cellar: :any,                 x86_64_linux:  "13a3c03f6e821b12af217c45b65202df0102c90a8d3767120023e9ae893a9eb8"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "server")
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin/"sonic", "-c", etc/"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var/"log/sonic.log"
    error_log_path var/"log/sonic.log"
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    pid = spawn bin/"sonic"
    sleep 10
    TCPSocket.open("localhost", port) do |sock|
      assert_match "CONNECTED", sock.gets
      sock.puts "START ingest SecretPassword"
      assert_match "STARTED ingest protocol(1)", sock.gets
      sock.puts 'PUSH messages user:0dcde3a6 conversation:71f3d63b "Hello world!"'
      assert_match "OK", sock.gets
      sock.puts "QUIT"
      assert_match "ENDED", sock.gets
    end
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
