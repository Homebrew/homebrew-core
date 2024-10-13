class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.3.4/veilid-v0.3.4.tar.bz2"
  sha256 "b581ef7ac4098ea20e1e934444f8ba7aaa340257b15349556324994621a8f146"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bf13222d557e463d5307beaa6712313c6e71d67439e2823c5da0ad0ca3da30e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f20a2ed5f70c61e7319ab7eb45f819b0adc9915c952f3892606e92b8a33b6595"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "902e389ed5b89b886e23d3134785a571b4224a9908e1c08c820f496957d97efd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2cd376965f88cf0bef966694d9e0e8d2223feb9ffe7e3468f4e2a8f66fb2e99"
    sha256 cellar: :any_skip_relocation, sonoma:         "63af1aa6a4e0697a195fb653c83f0e2aecd9fe6063ffddd89e6efc1f5246b157"
    sha256 cellar: :any_skip_relocation, ventura:        "a0075e9d01392f23656a6ba58c0801894a74a16f7211029ee0fac55d67dc56e8"
    sha256 cellar: :any_skip_relocation, monterey:       "c53848b6ee8d02df5b7cb693da7563fe3ae815892066e3de10877b5b4d57ac96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b1262b831aa8a087f4f55a85426db19f94e99743462487810cc2ed43694aa4"
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
