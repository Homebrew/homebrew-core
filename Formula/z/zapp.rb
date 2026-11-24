class Zapp < Formula
  desc "Flash ZSA keyboards from your terminal"
  homepage "https://github.com/zsa/zapp"
  url "https://github.com/zsa/zapp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "46f7414f8407ad9e4d63b44d2a80e508cbcc36253c77e50c447e3f48d25759a0"
  license "MIT"
  head "https://github.com/zsa/zapp.git", branch: "main"

  bottle do
    manifest_sha256 "031dc9c3d3d885c7ba74261420dfa42eb6a9e53afccc381feb428b24d6272d2b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "767cdb4116a76adb10a80ca357d809d548b02123da127303cfd448f51069216b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb57ce43a58a8ad9fb44ed59d4f924fd36bb636734a1a4d9dc28b5a64c1a3a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a7c530b2cb3b48e75c89d865f38f639a15f567d84ad56ae12ce9e71262802df"
    sha256 cellar: :any,                 arm64_linux:       "d5afce1064f04a485c358045f9bb7014bed45e065b6e62d40a2c8ffdcf6c1f39"
    sha256 cellar: :any,                 x86_64_linux:      "7bde3c298579df32202e94551e838115a1990558e1c75f27b607593b521294fb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "zapp")
    (lib/"udev/rules.d").install Dir["udev/*.rules"] if OS.linux?
  end

  test do
    firmware = testpath/"invalid.bin"
    firmware.write "not valid firmware"

    output = shell_output("#{bin}/zapp flash #{firmware} 2>&1", 1)
    assert_match "Error: Failed to load firmware", output

    assert_match version.to_s, shell_output("#{bin}/zapp --version")
  end
end
