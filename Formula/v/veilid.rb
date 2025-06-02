class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.6/veilid-v0.4.6.tar.bz2"
  sha256 "bb1f7f2e0360860d37f5744c909b135890ae876862cd8c01db1b138debbbdd83"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e209b9c1b7b0b07db54429e05d94412f439f75831fb3c229c442fd5979c4433a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d80e22029053fd1dfaaf5c724ed22322a7a3b3cb38c7f0483418ac69246429e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd12ce3289797749e329333463657b9bd3df67cb1bb7da30236378ceb21101b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b03dce08deab12500a080f1abf3c4d0e76dcba45b8e5eec255eb721fbf657b43"
    sha256 cellar: :any_skip_relocation, ventura:       "8461c72e64a1ccab0996a88cae5dc3b55a1dfbb920582c571e8e8f0e5ecc76c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d01721bfe5eb57ffb8fc01447e737773d77dc6424ffad336ea65fa3b5e4edcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d30c4cc18b0fef161b437c8c77019a23cebf901971204390a32533f4ac74e2"
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
