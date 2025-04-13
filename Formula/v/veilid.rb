class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.4/veilid-v0.4.4.tar.bz2"
  sha256 "3ea23446646e2e2307b5fa7be4e8de66e960578ec0067a87bf01e3463ad151c9"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9505daf806c14233ee9719c248f0c444b03a75b5ff2216391aebace74d1906b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bff5ccd91ef2112c14d88d5f152f58c99812a39e95abed05738f18bf60289a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76742ec819b228da9b0c4964430388b1bb99386f1ca30e6c044b0f96b8c05ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "533bbc60ae8ca6941f1a529c3e0b717fafe6bfea98734d1d5885308fe3b64e81"
    sha256 cellar: :any_skip_relocation, ventura:       "b9f13935b065fa618eb638ce9be1f0c18ded26dfdae0749f60ade343eb7e7e70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed993339970aeecd071f5dbdc90485536c878b1622601d4771da105ac1ffe920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "074dc8d4eb854bda8dcc573c20689df2004768487c27d9e61f6938240a600c58"
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
