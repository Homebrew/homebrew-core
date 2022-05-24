class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.3.2.tar.gz"
  sha256 "e07baccdc24dea6a6c0e6ef32e7faa3945318cfb2577127806c8558f1809283d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a83b70518118c60edcffeab87cfb3cba1b9aef41aabd3f5e669617891cae25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69a14bebca8661994dc69b839f3dfce7102521ac8ddbea53d8787f0e7529cfdc"
    sha256 cellar: :any_skip_relocation, monterey:       "6f7b0d809dfe6ba57810405827a63daabe4c342c9fc49b4be82a21b20880c226"
    sha256 cellar: :any_skip_relocation, big_sur:        "792785661a775679892c9bafa85c35672e8d2ef2d165ea288cdcff840e156ccc"
    sha256 cellar: :any_skip_relocation, catalina:       "bf838a42756d6b49113bc80343bfc97c86ad18d3f6535ab556dbab3fbded1974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3f700885fd76cf4dc2df760b710e6fd20b7dd1a4d5519895f43b820224c04dd"
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
