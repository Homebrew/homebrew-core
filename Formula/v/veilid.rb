class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.3/veilid-v0.4.3.tar.bz2"
  sha256 "979bdfeb6b125d20959fd28f44c7b1afc919859770d02daf123d58826df06427"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4304922bd7c98519f8f0be1979b9205cc8763992200b3f782a6d8590920fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a542683bcb170da20273db06922991fb846d11cd38c535959672d8bdf1b0d46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "702efed0e2a6539e1872f98657053303f9bed1acda9344cd01322d2cf95549e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d70d95d8018a74d50576c4db3fe1e48e3067b43227b99408251c94c00c15a0"
    sha256 cellar: :any_skip_relocation, ventura:       "9e1cf70d7cc5d4a737aeeb340ec53283105de02d91305491655eb2ea210377f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b7b166b1e060be8f07c2f79247b88fb0dcf4577374ccbc724cbda2e92ba9d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5554744fb5b82c3553b7853ebf05f33c7cbbf18d6bc4d8a45395393d25773556"
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
