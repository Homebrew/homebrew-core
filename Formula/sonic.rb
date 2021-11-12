class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.3.2.tar.gz"
  sha256 "e07baccdc24dea6a6c0e6ef32e7faa3945318cfb2577127806c8558f1809283d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebedb9e208b648cc627db1143c39090344237ff84f5fa679e0a2dc5f22d25797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40836359c104cbccb54ebdc2b57601282dba48acab56ab900834e0b50422374d"
    sha256 cellar: :any_skip_relocation, monterey:       "58b056515384251c2585bc1236f241b20fe9c2323758eba44a97db13b995181d"
    sha256 cellar: :any_skip_relocation, big_sur:        "460b0ff1c31b440347c8fce3afeeb0c8de5d5cda9db011b947bf872020fdb85c"
    sha256 cellar: :any_skip_relocation, catalina:       "4e626479ab425dfdc1f1dec05c1b46b82b14bf7aaf96bad5bf234b87562d8ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc1aac4fbba759534908d4f7810d920e5df118f8d02e74595011cf64c762f2b"
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
