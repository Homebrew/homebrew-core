class Wthrr < Formula
  desc "Weather Companion for the Terminal"
  homepage "https://github.com/ttytm/wthrr-the-weathercrab"
  url "https://github.com/ttytm/wthrr-the-weathercrab/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ff5b47f2046ebefa9ff28cb52ece49a06f7b89230578801c338c77802aa721e0"
  license "MIT"
  head "https://github.com/ttytm/wthrr-the-weathercrab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374e60034ee75ae89b1ed428b0fccd1af6283c04579823105c05da9edf09b77e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762cc039b08678cc91207e5aba373a9926b4d7f6bd14b154080ec4c9f0144778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423b5d934ed4948e6f91ff46bb6122fe3ef4801357cbe1323abe055e63a4bac4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5c71252f0517231d9b7ea64314591586df9419d5529029c4ef1d7b6ca73b315"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0a81d0cd757022468358c46c11db2ed9e34baefce396c4403ded61b65088f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "6b4fdbcd8131123e488055b26f86a6ef912445e4a200b915a9ae4f561a45a753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a3a3a1958b67645f20100308854792cc55ddf067a31f403bb251ccb5c2e28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d8bda45cf33d2ec34c043302a42b9551d9d7c33dbdc0421c80ccb599db8219"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wthrr --version")
    system bin/"wthrr", "-h"

    require "pty"

    PTY.spawn(bin/"wthrr", "-l", "en_US", "Kyoto") do |r, _w, pid|
      output = r.gets
      assert_match "Hey friend. I'm glad you are asking.", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end
