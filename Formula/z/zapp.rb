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
    manifest_sha256 "2da54f8b355d8cb84c9b13a84396fe68d0ef48f607b07a179ff4a42507510a1b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e681204b9f1ed0a0294f490178b8292f07bf4ffe40826ad38d2d61f984255a64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "131dd509daabf3fe1c7d074d04d6f45f9ad5b0ce3927c7ea66de9aed82dc6437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8016802107f6b08edf28bea74dc1c5eb21574ca740cf6a446f6d7427e82ba3f"
    sha256 cellar: :any,                 arm64_linux:       "e1f59b921be071638b9a1837efb69034f108456ad77cb97cdf7efa020bdf659a"
    sha256 cellar: :any,                 x86_64_linux:      "7189ae5d3b894ea785e5d8210a9c97b82a32d0dd4cf4b86543b06c739b91150d"
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
