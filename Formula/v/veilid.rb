class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.1/veilid-v0.4.1.tar.bz2"
  sha256 "f7b3871fca4ffc032ed131721386d7c0a619cd9775a3e26666f9f5bbc9acc4ce"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4735b64b4f9c8046ad27bb172bcab0cc59e193da526743cb448b9c252eb2d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f2185a1412cb3a4a80655551200a58f005d9628f6d46f01ec2113efe6575e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e099f7dcb706845b9b1e668c4d62e37d317052b866b4acb808746236339d06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd98681cbac350cd7f9b9978d4b0149530c917870bf39fabddf0e1ffcc7514c"
    sha256 cellar: :any_skip_relocation, ventura:       "a26be37482264472296714d9c0f2d6294c78a0fe8bd176b4d548ecb59bfb1362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410e7b357cc11816a0339e78b1772d83b66be297909141fbe02abdc04ce5d899"
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
