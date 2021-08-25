class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.3.0.tar.gz"
  sha256 "6f8c1a8779f71bb57978f0baaf65ca65493f4d8a030895b74f579ce2b4e1fa5e"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "96cada862d795baf29e21b10735b373117c4c0fa8058cd48f31b9dbe24e954bf"
    sha256 cellar: :any_skip_relocation, catalina:     "fb2bb9eff6d9c7e20e6c86cd8279772d9d2be7d4969eb93bd8442ffac4a57663"
    sha256 cellar: :any_skip_relocation, mojave:       "7b2e9de3bed6b681c2b2cb21b784841f5153c55085579fb0598e0c939a033a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a6bced791e9b3429d6cc5cac6848ced5c83f397997d2ade7d8820ba2def863ab"
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
