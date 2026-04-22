class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "640cc119990994494596aefde64cd84f67cea843eb0199c42273cdc553324df2"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d79e0a32867d36d36130b4e7a6810f9f7d1c0725109092e5d4bc1b9f31bf4e7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a506f27327bc8698a1928380b71aa6f6f351f8e1a58cb2ba0b8293352cca9c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da81157e4c307b3a79d38be21a06f8b780b2dc2d13f96e8b92c59a0833a6abb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "568a19c5bb22641ea44c43068a09264cd64f624a31991876c9b8bc4317dcc258"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de21ded31143e97076ea81b2a1446243accf1c0f48a73ff69e6de7bafef82f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2703425cabeec694320b9f7346b60463c107178cc52b5426586bbf2478c33b"
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
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
