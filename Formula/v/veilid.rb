class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.3/veilid-v0.5.3.tar.bz2"
  sha256 "ed8b79c4420ec0f804b3d7a6638ead3787f65728144c663ef62eddf1d48e1806"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa6dcca09445d167b04dd5053970e2361793952faaec863a41c15aa41b8d4a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7b1c3db7bf6f6f0c96f6be0aca226991d357ca777693ee186bc943a304a068d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf148cc4007c6285a82a25da525e42034435681564ef3363d64f93053f3480ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "468ab16a232a7613ed12cbba5b3309a6353a6692c47da5005a910e571aed4d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af0bed410375ccb67df0d770874802736cbe0bfc8984efbb9b08c9da32ba738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "450238886cc05682c8d32b4a1fb411e016ca07b77dffa99a28b7666728500e75"
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
