class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "e17bdd7ee68dd4e7fe4d992f134a5819c3af63a8dc467a6f092450e8e744efc0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5df83ddd3c235107da258734e7b9706509ba185ef576584c8330d03807c82844"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1cfb531591a40593eb201b5029b139697aca06cbdd4fd08426ed4d2c28b0cd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b731a264f1388a0cf976114fd155d885502cedd2f2238dba389fc9b6b6668c7"
    sha256 cellar: :any,                 arm64_linux:       "3ee5ce055b9d547357a8919d3751e37707e39262b48f32f0585a0d25b488ff5b"
    sha256 cellar: :any,                 x86_64_linux:      "343d22af66d4917ea629365a5f22b3278a115b7c9f044d3d3fe185f775cac2c6"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
