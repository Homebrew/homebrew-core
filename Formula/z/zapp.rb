class Zapp < Formula
  desc "Flash ZSA keyboards from your terminal"
  homepage "https://github.com/zsa/zapp"
  license "MIT"
  head "https://github.com/zsa/zapp.git", branch: "main"

  stable do
    url "https://github.com/zsa/zapp/archive/refs/tags/v1.1.19.tar.gz"
    sha256 "836aac5cfd7579c8a51ebe353c574afc0c5bfd1514e10c6530c44863e269bad3"

    # Match the CLI version to the release tag.
    patch do
      url "https://github.com/zsa/zapp/commit/dd22bd7d11aa5b3990143927060e6404426e75c6.patch?full_index=1"
      sha256 "f65a3fc777b60bcb33cf01a40ae4f9b3de0a78471f5858cad80aef0a8af17b03"
      type :unofficial
      resolves "https://github.com/zsa/zapp/pull/17"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b6eb6ef49526ae48365f7bb7233578bb8d225531f5dcfb813f03a924d90f9c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95015fd91c652035203cb3fbd8cf14f5edb3386990a44232a5d57c234bb3d287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4fbf2474c5153579da52662e7a690ff555085b1959367a53ee17b8400be96c96"
    sha256 cellar: :any,                 arm64_linux:       "19d82907012590034ecb119cbd22a38690869d3d04e69ed3f84bd6656d9bafc3"
    sha256 cellar: :any,                 x86_64_linux:      "b88d8b34e2eac8da390b175de650a2401789b798979aa7fd7a15bf79d9225a5c"
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
