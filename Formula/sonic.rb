class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.4.0.tar.gz"
  sha256 "953314a8c711fde89ac5a7e41ab37d35fffa2b5cc6428d849bc65968e45a8cde"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba4c2939b999ae73c46cceecb21e25f67f2c0107d8fc53b4ffbe5337299a66c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a2d41df229febf3a5fc32b1af2c78657810e12ef94ca9522a318b590365bf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42ec66f78a25bd41bfb235b6684aa4f17c7360a5cdc2fdff6206b9be0c0b62e0"
    sha256 cellar: :any_skip_relocation, ventura:        "cdc64f315ef84bee7373ce6d79bb3d556ab9f834c2a1dd69a096bcb5bef9cdbb"
    sha256 cellar: :any_skip_relocation, monterey:       "00d1c7357fcb1261433e54856267d7c653701b8d154e4951cd16ba70fe66c3c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "322caf905b32c77a887ac05a5c9d78d1116e3af9701ecc27652c813d86c9f1a6"
    sha256 cellar: :any_skip_relocation, catalina:       "9396cb130cd9db11186a103e19371ff06d1e6e72ef784f5b9f94415ef29dfef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a26ea1c3ca5619ac1f72d37526b47862512c136bc0e56b24c5b023b72c1d42"
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
