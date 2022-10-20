class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.4.0.tar.gz"
  sha256 "953314a8c711fde89ac5a7e41ab37d35fffa2b5cc6428d849bc65968e45a8cde"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12cd94403578b030f96f2208528abebb6269cef80e06efbeefbc8f5baa8ce782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52af62adf108a51d03bb005b9b161c6dc956afd80760bb2283728e66591d5ba"
    sha256 cellar: :any_skip_relocation, monterey:       "0c45791287c7b6908028c6048231a2c59a88f502bf47968df9013f9ded539e5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "806778d9239d3131ab09956665d21676dc999b03c5ab1bb10bb1b2a4120a988f"
    sha256 cellar: :any_skip_relocation, catalina:       "7925072868e77b09a96c3bcc99cf4f3f986792269cc4702a6f22ee1e7d741f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7332b36992b4248bcee2636e67591d58805447a97387703d53f03e88497ce4d"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  def install
    system "cargo", "install", *std_cargo_args
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

    fork { exec bin/"sonic" }
    sleep 2
    system "nc", "-z", "localhost", port
  end
end
