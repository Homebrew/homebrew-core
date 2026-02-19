class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.2/veilid-v0.5.2.tar.bz2"
  sha256 "c95b6157c8c3df634b6b8b25fef01a83a933c1f42b697a68842799694a2598b8"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff48154cbce45f6ad710afa3117c942d4f92a00b860bb19253e5e7bc19cd6786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4afdbd68236d1e3a8e7ed657b7f0f38dfa2edf2778dead101aacf9a674c66fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28af2ab66b164e3f3ef4666c81cf3872f546a251c885aa35ac245c70bc93313e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ca7e3ddcd6058124adaf1e01d06aa751b059cae501bc17a1e67cda98f4054b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951e22994f2f7c0336ee7d0ad15ab3e9e96ea15b843a23808812ee7e362adf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeef8192bd8e3c355ad18e07156a4c1993dd1629fd96dafc5c714b513d5a6f9b"
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
