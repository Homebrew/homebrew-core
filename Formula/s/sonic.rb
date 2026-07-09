class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "494bfa464d410bda4591e07bec5d8b9ffaa9381d6c2b3570b5653c1ec5b36ccf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82e1be2fbe3ca7dbdc0239c2437f44f12722b905eeb6f63653879ea0224cd2af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ea18ccb14f6916132e24bad947c1571b49a7391e7fadea4c382feb41ecad22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bafa63801bdfe99ea87a59d103dc4668550e27efdfb9151150b64a64001a17b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1422ef48f5b6432782fee940e3cdb9e542bb7d51a395ed48020fbbfae8f2d201"
    sha256 cellar: :any,                 arm64_linux:   "49cf04591a9f2fedf9c5c15a43ec730f324bd5c582a2171aa887a6fc7e66f462"
    sha256 cellar: :any,                 x86_64_linux:  "15bc792fb2460de76809a322c8ac86c9ffb0e6f4cec8a980ff2aff86b2cf00d3"
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
