class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.7/veilid-v0.4.7.tar.bz2"
  sha256 "5df6b4d8978958990549315ae6ff2b336c9e9b0606ce316f42b5fc2b31fa07e5"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b2828d8b246267a4d35fb0aaf36f4f890edd6df535705753e08f7a2d48bafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44c214b57c8b84bcbf2ac61d17529181ca9cb6c9969139c99f2f0fd424a08f00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0b1bd89ac7a12c5141995f66923e4450aee26ee17f146d000de335081c716ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc4601ac764c6fb4ece4aac02f1790084a6394a5368219854a14950ca8c2146a"
    sha256 cellar: :any_skip_relocation, ventura:       "f715e4fd93f6afbc3ded77efef8baf173610a148892bc7255ad7060bb11435d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c585f4fd38d6a3b511680ca4d2bbd43138b60d7d33a80a82768c501b3014cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20e5d7f32d54285919c50a51a32e5b87918bdbf6e0ded3d36437126efdeac78c"
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
