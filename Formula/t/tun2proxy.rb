class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4d13b3aa9da2ea1d640e84e8d9b90628d971a408c1099b6383e1d4ea5191ad93"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba08713a056a0fec31a6bf0065586eebb8010c2d784e17e722c626b065183f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c586809f8df60ca912f0e76a9ae5853fe9570fbe6f799cfc66a4888066e6b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88b8d717ff6ad94a3bf2abc850e7adc6639a23e93a572eefe6570861bc99c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34de69b8d800fb0ee077d772ebc17c805ca34897e0fa8fdd2c830849a4adba5"
    sha256 cellar: :any,                 arm64_linux:   "70c008b03c4f2d1bf61eb3b9c6e18b613c6c32dad5c89cd90d10605c4b54388a"
    sha256 cellar: :any,                 x86_64_linux:  "ec4b71c4ce00b18dd3c98d1c9a7f9c8adebec8a86144970412679f20f366ab09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end
