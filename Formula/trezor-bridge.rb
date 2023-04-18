class TrezorBridge < Formula
  desc "Trezor Communication Daemon"
  homepage "https://github.com/trezor/trezord-go"
  url "https://github.com/trezor/trezord-go.git",
      tag:      "v2.0.32",
      revision: "9aa6576af6fabd557bc298d1a12b73170f467a07"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "464cb3ea9e6f6e2c621df01a0ee1a4c06914a97f972818b84fe84f58f806f011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f3201ea207a6ca5554018ef16a574866a5b207f5646cc4373a38a7ace5df41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffb43f934abbcdab466a049a02eb6b1931d8c232ef53dd6ad62d489be7215cb4"
    sha256 cellar: :any_skip_relocation, ventura:        "3031a38ca271f26f3e6d948f8bdd2d10d77e6eb9c1beb9bad3e8aa4f14b36c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "0dde76f3050a020bcfc4e9b02586e4ad03414a16997ff328ff3577a60280aacd"
    sha256 cellar: :any_skip_relocation, big_sur:        "135b5e71c548f7995da5ea8c43059e4527f2e08f38c15715b387a54b6e993426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454855de505930c7876421c843d13ddf6e9c34fb67e8c33955b79e6189475411"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"trezord-go", ldflags: "-s -w")
  end

  service do
    run opt_bin/"trezord-go"
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    # start the server with the USB disabled and enable UDP interface instead
    server = IO.popen("#{bin}/trezord-go -u=false -e 21324")
    sleep 1

    output = shell_output("curl -s -X POST -H 'Origin: https://test.trezor.io' http://localhost:21325/")
    assert_equal version.to_s, JSON.parse(output)["version"]

    assert_match "[]",
        shell_output("curl -s -X POST -H 'Origin: https://test.trezor.io' http://localhost:21325/enumerate")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
