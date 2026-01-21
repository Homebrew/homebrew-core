class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.1/veilid-v0.5.1.tar.bz2"
  sha256 "c3efec86cd7358a214eedc648558e10433dcedd089dfa324f9dc5ceebf8bb50c"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74458597efff1154af3aa7c9f0f4045b301c49bda29962c25096f28560d1fe3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70abfc74d48e71bd1c784bc1ad8a76704bfe159c4a319ae4b18eb0345506d4fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032fa0d35851ddfc8d78b56e72588fb519e43069c5dfb3469b9c3d4afaaeab11"
    sha256 cellar: :any_skip_relocation, sonoma:        "1719f80e8e0d0abfdc05bb09c32b049c56d247d613aadb948b340b9e3cc67409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4785a646dc4ba4c88ed3a32fd3f0aa23538437a1169a025def1d20e2e61a3c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b6acd3f512b9e242364bf57712264eb55bc56827b3fd8b9140a83575ee8d34"
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
