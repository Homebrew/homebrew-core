class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "23b846bce0cd92f0f94dd893b8b4c6ebc227680d532bea6a33d4d9d72c153911"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e0435c7856aab2d4f302a299007daa5e815229f980d2199314b796ab31a71d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f7aa1d416732f97878d63339b38d36a4e1fce93dafdfa212b67514c2eb17af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d2d7e9c47e8ea5c5683002e667d39fe21f6f012dd515c0309d48a9a8bc8528"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bd039b2d537f4757ded7d157037f16db6e9ddb5f44875956dfcdcea9a51f850"
    sha256 cellar: :any,                 arm64_linux:   "baca4f3d377b5a7711b9ee6c99e42b4942fc20fe79d29890aa843226c8cb7a65"
    sha256 cellar: :any,                 x86_64_linux:  "6b2663797a448b2e7b2751e0318cc59b996b10ab0e472a89b9a514ab2e395c38"
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
