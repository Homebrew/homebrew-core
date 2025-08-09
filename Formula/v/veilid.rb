class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.8/veilid-v0.4.8.tar.bz2"
  sha256 "e041a1b3d2008cb51c3b18daf5d760d45de39240f24b8bb0cbd78b02aa7375fa"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc83f6add3d8dde4022865a2550d36785b225416cf4ace8a7e99aadacdcbced3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5de3a975f3cdfb20282c46a450f968d388de863895a826cf9d937cc28bf00f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2825c7d5a01458d7f62cbc647d670abe6a9f4f01643406d34293f36f27796c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc411b1b3d47fb7cd2c8fa7a68693c4712745b75c318a1808c7dfddc1b8f2652"
    sha256 cellar: :any_skip_relocation, ventura:       "ec4903f24a6ae73681ebd5dbb0d7f67389f755fe9664e1bbb375f5b3972324ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e602e9e06335bc317df05efcab32500b84d4335110b48f6486fb953def441e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14dc1fb479b303a9b35f846fec42d9289a683a4a85c75f9763bcc7071ea78b27"
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
