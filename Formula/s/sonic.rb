class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "703b3d979f3cb72ed6c1f3535c2a4c4851107972eda3cd34a88542724f537181"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c75ce6f8389d69e5a0efab866be05145b06615ca35e35268e0d7bc78335fc4a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bc99dbcd2262ba06b582ae26f3aef36652c1c61e1c98262f7520585b3730ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fdf796638a103a809318b252359108821f17e9fb2c8f75d88d19820321541fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d76808c045782af3e01b67ea1bb1def19a835ae542535260ae642a7e7b693fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "79556244b4f4da38f9481116bc28e023709f2d3ff326ed51c2fd63e37dfff602"
    sha256 cellar: :any_skip_relocation, monterey:       "538f90545efe6392d352c1a293e6bfc2093a73b7b796c41a439d07d7a858b3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abeccf0b9b9070be03f746f9a4da886a7b5cb2286e64ca95a03033873f28fa5b"
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
    sleep 10
    system "nc", "-z", "localhost", port
  end
end
