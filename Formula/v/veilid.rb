class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.1/veilid-v0.4.1.tar.bz2"
  sha256 "844abd75e2eedc9e319c0a852b5e61b7064f96da702e30608a9cdad11b96e1a2"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7624f25271709427ff55e4ed08367481fd3876ddfd5bd22090d1651214764b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff210b06a35023c658e00a2f691be8ec2c7d8581507f3a24c4bcc84c859507c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72cbb1e53d721c3d0a075d86412fe79ff8550ff1129b8e6c96c7a4dad29a5770"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b511850a9193ff2c91ef6d428a04e9deee0d8f3a311a4dd9526b1e3ea6077b"
    sha256 cellar: :any_skip_relocation, ventura:       "3055c6ad9d16bb8971d9b5a72b03a4a1b0a790cdd1d1b062b3399a83e9b2102d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab93bc7de94906aa59c05ca78e1501e68087721390806005bf6562e4b4bc308c"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    command = "#{bin}/veilid-server --set-config client_api.ipc_enabled=false --dump-config"
    server_config = YAML.load(shell_output(command))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server address", shell_output(bin/"veilid-cli --address FOO 2>&1", 1)
  end
end
