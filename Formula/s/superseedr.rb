class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.39.tar.gz"
  sha256 "c5b0aace7bf24952aba1e4f635ba8c64d28423c5e87b51e88a73d7ca237f33e2"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d01f3566fe805b433dafde9443f20967d7b5807e27a9a5fc38bb4623b066464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40d6924f5d30c522887c7a2a3c61f50f450a34489d2a64e9b96df9fa8d29afe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7104c73ab9674c991b34ee9d6360249319373ec47d70ced9d345fbda7bc3c8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ef64181ecf9ded9977afc9d147c6e819815e0454795900e8719f3b3a8cd0596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e98cf7351b13a2fe3b41685da1852bbf77b9a1e227adee142c96762ec957a01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e360ae85b9139e46f97fd3bb10bfb44dbdbd28395d064aef0210ced2bda2de"
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
