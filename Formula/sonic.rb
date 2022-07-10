class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.3.5.tar.gz"
  sha256 "ff6b72939e87d2172428ac302a3aa152ac8a37206b8b0d11e73ded14dcc8e858"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0516f6d0b48cdb1341503d7624a4331ba7a295fe1d6212a10da9fc126ed97274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "185d38158dec8ed312e1918034c686e7b38f60e19e018211bad81195ada48890"
    sha256 cellar: :any_skip_relocation, monterey:       "d748bdcdfc8006e53155bac2381e6f67a96b0058c9c6c37a69febe2b63caafe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff012f2dc4eb12de080031e39605d8a5a1432b42e1f25a8ba4500235e30b61cb"
    sha256 cellar: :any_skip_relocation, catalina:       "dff9ddad869f6ddd7847906a29ff8e340deca793ddbd4bb20f2d75da97abde90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b10085bc3ead567627b4a7b2f312754df2c42370ca4b9f2b2f0c16e9e48188"
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
