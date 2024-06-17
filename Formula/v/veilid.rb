class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.3.2/veilid-v0.3.2.tar.gz"
  sha256 "31d7ae1caaf76468321fa0d5970179a4459c3ff033807a70292971f738f333a6"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9214b93e4187ad44a8088e7f9b606056288fa086689b5362701f07e8f313eb5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "374b207ce137c2806a49c5ea00cf87052e241890fe2d30f6e08280c3e1482f27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161a78b4875dbf8f8af11f1d3827f0c8a4c72aad9482635aa03b228891ddc62d"
    sha256 cellar: :any_skip_relocation, sonoma:         "14da5a02dbf07cc476174e2476a6ef867f997dfca7dbe5416952bb74060a0e39"
    sha256 cellar: :any_skip_relocation, ventura:        "39dd9f488619d8c666a14a722c0e604a228b775c8a52de98bcef69088225d5b9"
    sha256 cellar: :any_skip_relocation, monterey:       "80f4343c8a672a5949986e2574f504797795da4a34aa1e699d9af42518d58376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e1d3a116fb19ce64855de6ac081c37cd17082d03bc9c9b213b215951d7391d"
  end

  depends_on "rust" => :build

  def install
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
