class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.3.3/veilid-v0.3.3.tar.gz"
  sha256 "27b1a995a5e85ef2c641f864bcd5dd576900df669bf718e5328cf6b3ca33d510"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b1522ee2149835789d659f023c65cb0c55b678e13e8701e7c4e1e19fd0aca52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27f029456061f2ac05dae4a2d0a4ffbc8de60e205d9c33043be07eaccda2789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "283dfbf227ecc6949e998f9a0fed8c48fdc2022c0bbe7ebc280c2f406e38d20f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6571cb8bca5089931062d001a4fef6a721d2751a7e9878357777a223028137b"
    sha256 cellar: :any_skip_relocation, ventura:        "fd5de96126979653d71e89b32e3ff9771dbc2bad774453de5f461261b26b4f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "de7ccf72144aeaeaae8449324f03605c291db8c3ea916b57d5f45c9ab55b4457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2817271ce8b32f2dff552909a7efd4703848e46df61b1989cb642c04d736173"
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
