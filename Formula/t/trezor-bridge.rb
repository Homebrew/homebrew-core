class TrezorBridge < Formula
  desc "Trezor Communication Daemon"
  homepage "https://github.com/trezor/trezord-go"
  url "https://github.com/trezor/trezord-go/archive/refs/tags/v2.0.33.tar.gz"
  sha256 "c80e0ba0e727ae2f7bd7a8b0f7082681296d478d1034c64a8bba64ce29239ffa"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2292705ad88081147e09d6245be6c0582f14204d88b28adcde3eee6e7f04332b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4402cab315a593f21dc76e910c36b4cc69725185897b78a74e944858bec9a1c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "103625e34a098ffc03095dc8d8a6e9d7535e00127e7da2785458c4d204798968"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a92454ebbb7d44747bbcc621adbf60a78ed2a4c8f2b32f600e92114fede2a4"
    sha256 cellar: :any,                 arm64_linux:   "3d76a7d87646567b04507282e6a1de848e4bb06cf07c89d89b2bec7a79ac962a"
    sha256 cellar: :any,                 x86_64_linux:  "20f99f81632453e3136a8ce7a1a087a61c97941ef3985eb558310cf1a02ab1ec"
  end

  depends_on "go" => :build

  resource "hidapi" do
    url "https://github.com/libusb/hidapi/archive/76108294092c023a4ece99eb3219559cea0d5066.tar.gz"
    version "76108294092c023a4ece99eb3219559cea0d5066"
    sha256 "b47c0a3463984fdc330c7cb42c5bff258ef6a0a718ea68b986c95dbaa505252b"

    livecheck do
      url "https://api.github.com/repos/trezor/trezord-go/contents/usb/lowlevel/hidapi/c?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  # Fix libusb build for newer Go
  patch do
    url "https://github.com/trezor/trezord-go/commit/318b01237604256b1a561b2fa57826aa0ebb218d.patch?full_index=1"
    sha256 "b48d0026281814f9a6a8cac48b701db741391d285867593b4ce272e70aff229a"
    type :backport
    resolves "https://github.com/trezor/trezord-go/pull/300"
  end

  # Fix build with go 1.24
  patch do
    url "https://github.com/trezor/trezord-go/commit/8ca9600d176bebf6cd2ad93ee9525a04059ee735.patch?full_index=1"
    sha256 "3eaa5c4bcc09a931e2c07ca7a6183346ee07ca5cf98e75a0ee237677e3269a7d"
    type :backport
    resolves "https://github.com/trezor/trezord-go/pull/305"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    (buildpath/"usb/lowlevel/hidapi/c").install resource("hidapi")
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
