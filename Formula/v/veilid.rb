class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.5/veilid-v0.5.5.tar.bz2"
  sha256 "c2c8ec7669277d3172c973a7f1907238243b989f82983cf20e970979fcd9395e"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47812b8bc28648b07a0904ca5fb360317c23bc0256bc675fb1a503fce6d4177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f54a4bcaecb322688cf107de3abd6066e65a78854c16d4d7f5d432f30257ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83dc1c6cddbfc29bdb9bfe264a8504967d174fcfd39b503198995e2ef1dd22e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d61977fd6af0c3ac957855f7f47869444908cf8d02bd995903e59b637aa66c2a"
    sha256 cellar: :any,                 arm64_linux:   "3ea716d793b44a54753153c8eeeb3bdc3f134887a33bbf5bad612abfef17d645"
    sha256 cellar: :any,                 x86_64_linux:  "5d9a06f825d2b0ded3e5bc1dba2f7a90cbc86e9b3007110b44053386d01d46f3"
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
