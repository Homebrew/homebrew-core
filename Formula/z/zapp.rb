class Zapp < Formula
  desc "Flash ZSA keyboards from your terminal"
  homepage "https://github.com/zsa/zapp"
  url "https://github.com/zsa/zapp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c4e03dba5d87295d565c6681b3b13956160c364be637bd6756d438fdb3959e4e"
  license "MIT"
  head "https://github.com/zsa/zapp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c4bb69b2bacd8f176cbbb602ebd9a52ac362504727cd522761013e0a0adcf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80d4c6f98cf65f63158a8532d1607922530671a25ec1c384c9d95ba6b587968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "267f0166abbf8fddc46de86b8d6b99b0291460ea2772ef992f2680f60b28dd20"
    sha256 cellar: :any_skip_relocation, sonoma:        "be5dd2078f26df35f895e0665102b4c1affcb18c0a7d25ab6635aa5cf52bddeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2433b52f903f8f0a1f880cd98245776678066de551496b274593f3ac6d0ee112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d410f68eb15ce979a74071c94bab70e56ab33f78520b2308d188aa18dcb0158"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
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
