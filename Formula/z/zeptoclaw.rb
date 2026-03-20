class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "f0092f3cc76f64a38f925cbf06f09cbb17e14138809cc3ad4117ec4d3c6f82e8"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "522110160376648b1e0474de71e20da2a20bbea98e1c5b1aa60211e23fb7a91e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84dab583954c7c42868be8962d223a8671dded67f147d6926764c2749c975aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9187f7f50e971404cbb5bdc1bda2940ab64ca2ba38d151c990519caa3ea0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abeddf74f210c386d7542d595eab58f2becdee66dcda912b6800b089760610e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ec19e9d76bd12d28df17c6b87d41909c886c8a67085cf5a75abfd96e2762a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c4a50443d7ef2ac8696699a19c092fadc09e4e4d028cc7e369c0719f5d9b92"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
