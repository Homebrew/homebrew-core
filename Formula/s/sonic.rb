class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "52fb402422dfc8cbf42826309f0836bd255916b9caab1eb8990424d1ca603147"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e628ba0b3fd23ff4f6437130f74327f8d4837214f12722fdc8bd80c13b1a2300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc876ad1a89d8e5620e74ca54dbe31daa28996c1df0aab8b1a4abc1cde1cf4e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f555e6a5d85c4d4129d75e33fdc185ca502adc9c4faaaf081ef372395e56a76"
    sha256 cellar: :any_skip_relocation, sonoma:        "eafc2c84ce00855eda2a20c3a0b52a60ae040286919ecf9e6c162dafd6bdbed6"
    sha256 cellar: :any,                 arm64_linux:   "7aa741fba67bf375b8df82e790ecd5045bd240b80421a4489f2de71bd75239a7"
    sha256 cellar: :any,                 x86_64_linux:  "d5e833de13dd121136808bcd6f3f163962c9b065be7dcf523139c473c6e3ea79"
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
