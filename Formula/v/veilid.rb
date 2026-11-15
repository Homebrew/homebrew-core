class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.8/veilid-v0.5.8.tar.bz2"
  sha256 "37fd3b67a79f677b4392089de3fb6b1c42146d1612859fa1de5d402cfdf9858b"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "113e3bbca2ae73f6fba902bb5c53f7393cd892f41ffa08730608bbd7f39134b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67a24bfe2b1c6c702a96e698db236858b9e49228307318bb898970838d21ef30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9224978a03f6657b1a5e02e75f10131a6393b4236ad0cb519254bb2c281ee829"
    sha256 cellar: :any,                 arm64_linux:       "3dd7fa70d95013fc77a072bea73fa7133e46fac31f44ec62a709bba158b92f17"
    sha256 cellar: :any,                 x86_64_linux:      "122c72eca6e75e9282fbd819eec8781eaa3a7eceb868e75538d2c238a473bf6a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
