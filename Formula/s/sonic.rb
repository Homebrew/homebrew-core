class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "1db3b5a88f6b4590b68bb67e17c0d077c9a5e3a94b7a1c0ee2af827d3ecd4d2e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9a8b0ebf270aeedcefedd6c672596b541fbd3ca1c99d91256eb7f10c84ce53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac8b4a6f63353bc1c2ed369c99279275119e42904341b02baa17b0a6c7af6e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd10b98de0631e4dfd38d6020145279cbf7c8c928332acfb34068259599365b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1a3e3fe8e08f7f9373870b934ae1049af833308c052554a98e25c349f4039d2"
    sha256 cellar: :any,                 arm64_linux:   "99b6f4cf39edd0b65a9493068ce19ba65d290bc209f2a01296631ffa9fa4037a"
    sha256 cellar: :any,                 x86_64_linux:  "3f020959dfa7469952a2da19c49d87d449b67d470a84d74eacf7185d6e4ce8a8"
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
