class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "9cf63d9500286aeb77739e0ba441f0aeaf8fbaf8697fe93b2a7c4488285adc7f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f92ea8b95c12bf04ca279fe0a04974a1cab1aebef7b634748c14fc195460018b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0946ed1d302793526b980f2eb17abf0c08ade6424c4b16ac52567d0544d6bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "387e0c28f7ed9849955a9134db57858106fedb2f7c470dbb276be24a2f20ced1"
    sha256 cellar: :any,                 arm64_linux:       "f453c7a0e7e9b1d39f5e0b0619982bb3d88c28ae54f770047994282704f4d629"
    sha256 cellar: :any,                 x86_64_linux:      "82389d4926b02a358afdbebb8741cb3691c42c3c80e48e87d08a9cb4a667bd34"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
