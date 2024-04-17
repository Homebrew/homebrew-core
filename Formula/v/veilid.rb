class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.3.1/veilid-v0.3.1.tar.gz"
  sha256 "c99a90c09785bf595aef4219f6ce7d613bc3c819b1f4c60f935764b8d580231e"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a25156725807b73ae46cc5d1014701f00ee1af2218ffbafda421111550b42925"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b134dc671308d08b339e989a5bdeee0cc8a23658f6fb0d97b0c8aa1de0fbca1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf9c4bca03157983c134e3947f794606cd25377ecc2bc3e68c75c3bc65a2ec3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dc9ff8a32111974336a9cee92dbeb97640cd10c4e232ce19c5b0b1e599c65e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f625029bca1d042da65e330255b9e2a1ea45bdaa5b6e7fe0869b317d6d5e2269"
    sha256 cellar: :any_skip_relocation, monterey:       "0c960f70736842ac5606ef0ce09044760ed95c654c46c6509e84ed311d2693aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d832acae0d78bc3dfa335761ac274d1e27bfe784b9c2b471629b37a0086bd13f"
  end

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
