class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.8/veilid-v0.4.8.tar.bz2"
  sha256 "e041a1b3d2008cb51c3b18daf5d760d45de39240f24b8bb0cbd78b02aa7375fa"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "525677ac4688593eebf9dab60e5d6376e8767e003c02e2342b3d093e65dac612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d1dc507427cb58a58fec83cd77d9ec598c75c620a72f26a3dd7a6b241a5651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e382e18b9f3bcbc5def2a377a982add30bf2b5f008575152bdee97d3987d95b"
    sha256 cellar: :any_skip_relocation, sonoma:        "98401c46eaa313a135271fe7ecc25a119e424e9e5f47626691da2a4d62d1c897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b14dfbc0596ee79cfd15f42984127f78f9426e640adc648ea45220848e1e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2e03b649cbbd169478f337c6849ff56db23296b585bf9a849ccb8f71351b3d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.append_to_rustflags "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    command = "#{bin}/veilid-server --set-config client_api.ipc_enabled=false --dump-config"
    server_config = YAML.load(shell_output(command))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server address", shell_output("#{bin}/veilid-cli --address FOO 2>&1", 1)
  end
end
