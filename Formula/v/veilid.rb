class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.8/veilid-v0.4.8.tar.bz2"
  sha256 "e041a1b3d2008cb51c3b18daf5d760d45de39240f24b8bb0cbd78b02aa7375fa"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "224049716b76f63659cc8dfbce9816253c2014135156bdb82cf4bf2e45060168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0dfdd88564f4c28c64587507cd3c0582e8101a2b9e59a379c83e5b1847b5b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e496dcb522e3488234d4601c8f41ae5e1baddf820dc7b1841ba68ee9bc55c52f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61a62594593bad1a2c49bb964b3609c31be5f0f45c488a749894b0da24dfcc20"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb5957790aa9013587e83cff154328203222d4ac0b0e78ab442350ce63ecf16b"
    sha256 cellar: :any_skip_relocation, ventura:       "7bf67d2351447abc43bfd388cf97219d557490cab49946edeff1b47f2af0be9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e0e37857a00f7925f8755543301be83603695e1b9eed62c36d55808b1db28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141bf959d448b699cecdbf875cfcee61c502ae8049435ff4ad93565e3d7353f8"
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
