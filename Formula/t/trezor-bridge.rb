class TrezorBridge < Formula
  desc "Trezor Communication Daemon"
  homepage "https://github.com/trezor/trezord-go"
  url "https://github.com/trezor/trezord-go.git",
      tag:      "v2.0.33",
      revision: "2680d5e6f7b02f06aefac1c2a9fef2c6052685de"
  license "LGPL-3.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "571d4d50ac297d3cbf185c383d7e9dce39043801ebef303bd63b5a07bf819777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "026eae2c42ba181bbb882176d03e3592558cb7d2d946d3de7c1766c30dd4fdce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ed7f24a07138a009a6ae6f962138c0ea9bee316ebe730b534ba072140b48629"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c207cb9221f8c6ce8e813200cc98bd0cca5dd3e29e85e5ece6c74b0dce071db7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ad3a642fda0faf46777da05d3a0deb9f691e4a0bf60a4db5da213c2b1e413a"
    sha256 cellar: :any_skip_relocation, sonoma:         "55eab81dca886c7fcb19eef1859d7166a3db6a4a24c1bcfae2b49829af8c45f2"
    sha256 cellar: :any_skip_relocation, ventura:        "5f6906f339f0c85c6d048aff26fa7a87adea4e87b8e262f54dd482e7d31231fc"
    sha256 cellar: :any_skip_relocation, monterey:       "3c19a0c1ec5d0ede24e8178c9a8e79fa7777e266ce9a941fdbdc5fc7abd4f6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a1e934f0f4c538d7a228bcdf430b1f97df1c8e469e9cd685f8cfec93dd18334d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0039559d527cb2841e04cff9bb7bc59b6db17f6f74f442768af8a81776ccacd9"
  end

  depends_on "go" => :build

  # upstream patch ref, https://github.com/trezor/trezord-go/pull/300
  patch do
    url "https://github.com/trezor/trezord-go/commit/318b01237604256b1a561b2fa57826aa0ebb218d.patch?full_index=1"
    sha256 "b48d0026281814f9a6a8cac48b701db741391d285867593b4ce272e70aff229a"
  end

  # Fix build with go 1.24
  patch do
    url "https://github.com/trezor/trezord-go/commit/8ca9600d176bebf6cd2ad93ee9525a04059ee735.patch?full_index=1"
    sha256 "3eaa5c4bcc09a931e2c07ca7a6183346ee07ca5cf98e75a0ee237677e3269a7d"
  end

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
