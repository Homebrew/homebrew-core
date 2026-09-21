class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "cd6f3d31eb5064465f2bcf49260772800048f77d2ee6f54b98b23e1d6642ef14"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea6bffbcb2219d430e264db1f67bd315469fa21ba392bbcb81f5222e2dcfeae7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73ec4e8850ef7477ee77d7816e4e26465a817141df3a070fa1119c46293e7c97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a85a4ff8794d10c17adf2718572d98fc62fc70d203cc2c196ffa0906be398d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ce9c1c226ceb2a96c9cdaf3695d57d1bee60b4c54f92e24fe845fc7333f93a39"
    sha256 cellar: :any,                 arm64_linux:       "9471903a61beeab65c8ee564a1b442ff8e7397e0e0c14ffc01c38d5af2d0ac59"
    sha256 cellar: :any,                 x86_64_linux:      "26476009bbfe86a5bd0537c438f2d537bf32bd467f93087f28326a145a6d3311"
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
