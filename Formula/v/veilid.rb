class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.7/veilid-v0.5.7.tar.bz2"
  sha256 "25bef28e4e38a268644e2cb5b0d7a66c85fa0358f848d89ee639f088f5405e84"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5073f510207640f154cf9e694de080fa6de2052f3f4eda6c7271d2065460fb94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7b0644cd9ae271fdca5a2927551a416156b24327dec4e278e5f73bb21dcd88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15db42a71c5d68c6f8049e95805ff361a0b1bd7e5db410a9f3f166455991d850"
    sha256 cellar: :any_skip_relocation, sonoma:        "58e36d40e3961cd6f799f7645f0adce6760a3fbfcc7fe1c524cfe22e4af98c8d"
    sha256 cellar: :any,                 arm64_linux:   "f9126a67d72c72e67174dc1134fa80d3ad70b00405cc121ae0eb3ce50408468b"
    sha256 cellar: :any,                 x86_64_linux:  "f1b26f076a3bf821c298bba4ea1a57097b11c5d698d3b0045451df74dd8fafa7"
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
