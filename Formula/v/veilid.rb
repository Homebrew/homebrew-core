class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.4/veilid-v0.5.4.tar.bz2"
  sha256 "8d65b02df75c5a1623984c1da8559f1d3942bcc3a3acdfd89796636ebcc4186b"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe015cad037222575a78f4e5e941161a0818416a51cc03431df1c2ae44b659dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e44e337ab1c4add979e902426ba809bd55c60ad9bb2f63778e1ea323a08fb19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd5d306490a93345e7c983d27f825ffa3a5b77874e3dba5977c36b6954daf427"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c5604011809327b417b228cdb2b0c8790618349817a1979f1224e7ccde0715"
    sha256 cellar: :any,                 arm64_linux:   "0330fe838e0fe24f01c50de5d894db6b6a6dacd95e286a78ade1145cca17a582"
    sha256 cellar: :any,                 x86_64_linux:  "94d54ddcba787ee6140d17d213c0f1c3b14a100edf3622cf9d5cea6423f980b8"
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
