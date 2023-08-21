class TrezorBridge < Formula
  desc "Trezor Communication Daemon"
  homepage "https://github.com/trezor/trezord-go"
  url "https://github.com/trezor/trezord-go.git",
      tag:      "v2.0.33",
      revision: "2680d5e6f7b02f06aefac1c2a9fef2c6052685de"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "759841e8ae02dfd9e248af122d4ff1ea86fa431213b2254ca403b37fd19a7994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0527558397468aeb0f38d77106bf49654531cdd55fc0127d64f033b9b67a3cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e059630a7d145f304753624e8f5de997028cfbe2fcc601f80d55d0e8f61bd0f4"
    sha256 cellar: :any_skip_relocation, ventura:        "4d220b2bec0444f0e31f013ac437f404a970f4faa494f231f45b421b48aa7e7f"
    sha256 cellar: :any_skip_relocation, monterey:       "6a3f7a962d8470a1630bdc814454f71276685e7dbb4e13ccf1ec3308c5cf26c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "03d3b125c3864a6522166f6450eb0f91511f8ff38283bbd8def9b63b4e7922a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16bde2e78f260089f05327efb87cd2e287bd3d4f84cd164d45f883bb10e434d5"
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
