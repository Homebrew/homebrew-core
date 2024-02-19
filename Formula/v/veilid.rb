class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.2.5/veilid-v0.2.5.tar.gz"
  sha256 "167c9a140aadc69d02a292d79edf949027d70a02985a860f0068adef914341df"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4af59cf1c45d697760a57fd067a2481c054e9cc3308dd897710394e58429f37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f82fb89e37207ca4e33848df1ac88aa2310e913c268d972469a27ab65a15ac3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d90a504c2891dee26c2a774bad92b7d1bc9ba26b187292156a2b039c79bf1812"
    sha256 cellar: :any_skip_relocation, sonoma:         "6aa96311b4cff90ce917451abb0a0f018fa8f3ad2f5beca78f240734ecbdc153"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b6a3a46bc3b81553b6194660c68d4bd20b9f09beaf794953facecacf7f9df4"
    sha256 cellar: :any_skip_relocation, monterey:       "03e842aaad66d915437efc8828437f5c92ab62e1834e832c70d02c9ec7097b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3eabb1ad8a40ec4de9935563d716367fbb42ad7ed8e0c78ea44bc8b05bb075f"
  end

  # TODO: Remove `capnp` dependency once version >v0.2.5
  depends_on "capnp" => :build
  # TODO: Remove `protobuf` dependency once version >v0.2.5
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    server_config = YAML.load(shell_output(bin/"veilid-server --dump-config"))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server address", shell_output(bin/"veilid-cli --address FOO 2>&1", 1)
  end
end
