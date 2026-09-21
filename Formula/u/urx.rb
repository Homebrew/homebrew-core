class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://urx.hahwul.com"
  url "https://github.com/hahwul/urx/archive/refs/tags/0.11.0.tar.gz"
  sha256 "ff8f5d9bbd4c3ca1c3cdafb17a4742bc0f8a132ca2edc9b76d9c871af3cb4dec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7926fa5f1e35a4ce2cebc4f524094c0330fb219cc34603988bad470d1d9fe41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f82e46383b5606735a9967c4cff334a1a1c39322c4720ac05d41cae483c7d0b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdf94721cf7a4b18c9df53faf8ccc96e6dfa0e046289b06555280cb761176173"
    sha256 cellar: :any,                 arm64_linux:       "442d16eec1c295dc6f126ac2307b487b4d4363f2f97ce0445b0aec566ee5956a"
    sha256 cellar: :any,                 x86_64_linux:      "d36ed6bba8077396faeaa99011b7a0814f68b619483a150abaffb8e09753df51"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end
